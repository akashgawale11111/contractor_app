import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:contractor_app/logic/Apis/provider.dart';
import 'package:contractor_app/logic/models/attendance_history_model.dart' as ahm;
// shared_prefs accessed via `userInfoProvider` in provider.dart

class AttendanceHistory extends ConsumerWidget {
  const AttendanceHistory({super.key});

  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null) return '';
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  String _formatDate(String? dateTimeStr) {
    if (dateTimeStr == null) return '';
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('dd MMM').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Prefer the in-memory authProvider as the primary source of the current user.
    final user = ref.watch(authProvider);

    // If authProvider isn't available yet, fallback to SharedPrefs-backed userInfoProvider.
    final fallbackAsync = ref.watch(userInfoProvider);

    // Helper to build userId and debug userType
    String buildUserId(Map<String, String> userInfoFromPrefs) {
      // If authProvider available, prefer its values
      if (user != null) {
        if (user.isSupervisor && user.supervisor != null) {
          return user.supervisor!.loginId ?? '';
        }
        if (user.isLabour && user.labour != null) {
          return user.labour!.labourId ?? user.labour!.id?.toString() ?? '';
        }
      }
      // Fallback to stored prefs
      return userInfoFromPrefs['userId'] ?? '';
    }

    return fallbackAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(child: Text('Failed to load user info: $err')),
      ),
      data: (userInfo) {
        // Build authoritative userId and userType
        final userId = buildUserId(userInfo);
        final userType = user != null
            ? (user.isSupervisor ? 'supervisor' : (user.isLabour ? 'labour' : ''))
            : (userInfo['userType'] ?? '');

        if (userId.isEmpty || userType.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text('User information not found. Please log in again.'),
            ),
          );
        }

        print('🔹 Fetching attendance with userType: $userType, userId: $userId');
        final attendanceHistoryAsync = ref.watch(attendanceHistoryProvider(userId));

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Attendance History',
              style: TextStyle(fontFamily: 'Source Sans 3',color: Colors.black),
            ),
            centerTitle: true,
          ),
          body: Container(
            padding: const EdgeInsets.all(16),
            child: attendanceHistoryAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) {
                // Log error for debugging
                print('❌ Error loading attendance history: $error');
                print(stackTrace);

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 56, color: Colors.red),
                      const SizedBox(height: 12),
                      const Text('Failed to load attendance history', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(error.toString(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Retry by invalidating the provider with same params
                          ref.invalidate(attendanceHistoryProvider(userId));
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              },
              data: (data) {
                // Debugging prints to see API response shape
                try {
                  print('✅ Attendance API response keys: ${data.keys.toList()}');
                } catch (e) {
                  print('✅ Attendance API response (non-map): $data');
                }

                // The API returns the list under data.attendance_history
                final rawList = ((data['data'] ?? {})['attendance_history']) as List<dynamic>? ?? [];
                if (rawList.isEmpty) {
                  print('ℹ️ No attendance records in response (data.attendance_history empty)');
                  return const Center(
                    child: Text('No attendance records found'),
                  );
                }

                // Parse into model objects
        final List<ahm.AttendanceHistory> records = rawList
          .map((e) => ahm.AttendanceHistory.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
                print('✅ attendance records count: ${records.length}');
                if (records.isNotEmpty) print('✅ first record: ${records[0].toJson()}');
                // Simple list view: show project, punch in/out and date
                return ListView.separated(
                  itemCount: records.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final ahm.AttendanceHistory record = records[index];

                    // Use punchIn.date or record.date to build a friendly day/month
                    String day = '';
                    String month = '';
                    try {
                      final d = DateTime.parse(record.date ?? record.punchIn?.date ?? '');
                      day = d.day.toString();
                      month = DateFormat('MMM').format(d);
                    } catch (e) {
                      // fallback to formatted punchIn if available
                      final formatted = record.punchIn?.formatted ?? record.date ?? '';
                      final parts = formatted.split(',');
                      if (parts.isNotEmpty) {
                        final tokens = parts[0].split(' ');
                        if (tokens.length >= 2) {
                          day = tokens.last;
                          month = tokens[0];
                        }
                      }
                    }

                    final punchIn = record.punchIn?.formatted ?? record.punchIn?.datetime ?? '—';
                    final punchOut = record.punchOut?.formatted ?? record.punchOut?.datetime ?? '—';

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE990),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(day, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              Text(month, style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      title: Text(record.projectName ?? record.userName ?? 'Attendance'),
                      subtitle: Text('In: $punchIn\nOut: $punchOut'),
                      isThreeLine: true,
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}