import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:contractor_app/logic/Apis/provider.dart';
import 'package:contractor_app/logic/models/attendance_history_model.dart' as ahm;
// shared_prefs accessed via `userInfoProvider` in provider.dart

// Small in-file model representing a single punch event (in or out).
class _PunchEvent {
  final DateTime datetime;
  final String label;
  final String formatted;
  final String projectName;

  _PunchEvent({
    required this.datetime,
    required this.label,
    required this.formatted,
    required this.projectName,
  });
}

class AttendanceHistory extends ConsumerStatefulWidget {
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
  ConsumerState<AttendanceHistory> createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends ConsumerState<AttendanceHistory> {
  // Track last refresh per userId to avoid infinite refresh loops when the
  // widget is built and visible. We refresh only if the previous refresh was
  // more than 2 seconds ago.
  final Map<String, DateTime> _lastRefreshAt = {};

  void _maybeRefreshForUser(String userId) {
    final last = _lastRefreshAt[userId];
    final now = DateTime.now();
    if (last == null || now.difference(last) > const Duration(seconds: 2)) {
      _lastRefreshAt[userId] = now;
      // Invalidate the provider so the next watch will re-fetch live data.
      ref.invalidate(attendanceHistoryProvider(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
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

        // Attempt an automatic refresh when this route is current (visible).
        // Use a post-frame callback so we can safely check route visibility.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final route = ModalRoute.of(context);
          if (route != null && route.isCurrent) {
            _maybeRefreshForUser(userId);
          }
        });

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

                // Build a flattened list of events so we can show every punch in *and* punch out
                // as separate timeline entries. This ensures all times from the API are visible.
                final List<_PunchEvent> events = [];
                for (final r in records) {
                  final project = r.projectName ?? r.userName ?? 'Attendance';
                  if (r.punchIn != null) {
                    try {
                      final dt = DateTime.parse(r.punchIn!.datetime ?? r.punchIn!.date ?? '');
                      events.add(_PunchEvent(
                        datetime: dt,
                        label: 'Punch In',
                        formatted: r.punchIn!.formatted ?? r.punchIn!.time ?? r.punchIn!.datetime ?? '',
                        projectName: project,
                      ));
                    } catch (e) {
                      // ignore parse errors; still add with epoch so it doesn't crash
                      events.add(_PunchEvent(
                        datetime: DateTime.fromMillisecondsSinceEpoch(0),
                        label: 'Punch In',
                        formatted: r.punchIn!.formatted ?? r.punchIn!.time ?? r.punchIn!.datetime ?? '',
                        projectName: project,
                      ));
                    }
                  }
                  if (r.punchOut != null) {
                    try {
                      final dt = DateTime.parse(r.punchOut!.datetime ?? r.punchOut!.date ?? '');
                      events.add(_PunchEvent(
                        datetime: dt,
                        label: 'Punch Out',
                        formatted: r.punchOut!.formatted ?? r.punchOut!.time ?? r.punchOut!.datetime ?? '',
                        projectName: project,
                      ));
                    } catch (e) {
                      events.add(_PunchEvent(
                        datetime: DateTime.fromMillisecondsSinceEpoch(0),
                        label: 'Punch Out',
                        formatted: r.punchOut!.formatted ?? r.punchOut!.time ?? r.punchOut!.datetime ?? '',
                        projectName: project,
                      ));
                    }
                  }
                }

                // Sort events newest first
                events.sort((a, b) => b.datetime.compareTo(a.datetime));

                if (events.isEmpty) {
                  return const Center(child: Text('No attendance events available'));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    // Force refresh: invalidate and then await the new future so the
                    // RefreshIndicator shows until data is fetched.
                    ref.invalidate(attendanceHistoryProvider(userId));
                    try {
                      await ref.read(attendanceHistoryProvider(userId).future);
                    } catch (_) {
                      // ignore errors here; the UI will display the error state
                    }
                  },
                  child: ListView.separated(
                    itemCount: events.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                    final ev = events[index];
                    final displayDate = DateFormat('dd MMM yyyy').format(ev.datetime);
                    final displayTime = ev.formatted.isNotEmpty
                        ? ev.formatted
                        : DateFormat('hh:mm a').format(ev.datetime);

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
                              Text(ev.datetime.day.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              Text(DateFormat('MMM').format(ev.datetime), style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      title: Text('${ev.label} • ${ev.projectName}'),
                      subtitle: Text('$displayDate at $displayTime'),
                    );
                  },
                ), // ListView.separated
              ); // RefreshIndicator
              },
            ),
          ),
        );
      },
    );
  }
}