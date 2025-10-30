import 'dart:convert';
import 'package:contractor_app/logic/Apis/apis.dart';
import 'package:contractor_app/logic/Apis/attendance_porvider.dart';
import 'package:contractor_app/logic/models/project_model.dart';
import 'package:contractor_app/logic/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contractor_app/utils/shared_prefs.dart';

/// ---------------------------
/// 🔹 ATTENDANCE HISTORY PROVIDER
/// ---------------------------
/// Provides stored user info from SharedPreferences
final userInfoProvider = FutureProvider<Map<String, String>>((ref) async {
  return await SharedPrefs.getUserInfo();
});

/// attendanceHistoryProvider now takes a stable `userId` string as parameter.
/// It reads `userType` from SharedPreferences to avoid passing a Map as key
/// (which caused repeated rebuilds because Map identity changes each build).
final attendanceHistoryProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  print('▶️ attendanceHistoryProvider called with userId=$userId');
  final userInfo = await SharedPrefs.getUserInfo();
  final userType = userInfo['userType'] ?? '';
  final result = await AuthService.getAttendanceHistory(
    userType: userType,
    userId: userId,
  );
  print('◀️ attendanceHistoryProvider received ${result.runtimeType}');
  return result;
});

final projectProvider = FutureProvider<ProjectModel>((ref) async {
  return await AuthService.fetchProjects();
});
final projectProviderList = FutureProvider<ProjectModel>((ref) async {
  return await AuthService.fetchProjects();
});
final projectMapList = FutureProvider<ProjectModel>((ref) async {
  return await AuthService.fetchProjects();
});
final projectProviderID = FutureProvider<ProjectModel>((ref) async {
  return await AuthService.fetchProjects();
});

final authProvider = StateNotifierProvider<AuthNotifier, UserData?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<UserData?> {
  AuthNotifier() : super(null);

  Future<void> login(String userId, String password) async {
    try {
      final user = await AuthService.login(userId, password);
      state = user;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('user', json.encode(user.toJson()));

      print("✅ Login saved to SharedPreferences");
    } catch (e) {
      print("❌ Login error: $e");
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('isLoggedIn') ||
        prefs.getBool('isLoggedIn') == false) return false;

    if (!prefs.containsKey('user')) return false;

    final extractedUserData =
        json.decode(prefs.getString('user')!) as Map<String, dynamic>;
    final user = UserData.fromJson(extractedUserData);
    state = user;
    print("✅ Auto-login successful for ${user.userType}");
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    state = null;
    await AuthService.logout();
  }

  /// ---------------------------
  /// 🔹 ATTENDANCE HISTORY PROVIDER
  /// ---------------------------
  // NOTE: Top-level `attendanceHistoryProvider` (string-keyed) is used now.
  // The previous Map-keyed provider was removed to avoid rebuild loops.

  /// ---------------------------
  /// 🔹 ATTENDANCE STATE PROVIDER
  /// ---------------------------
  /// Manages Punch In / Punch Out state (from attendance_provider.dart)
  final attendanceStateProvider =
      StateNotifierProvider<AttendanceNotifier, AttendanceState>(
    (ref) => AttendanceNotifier(),
  );

  /// ---------------------------
  /// 🔹 MANUAL PUNCH IN FUNCTION PROVIDER (optional helper)
  /// ---------------------------
  final punchInProvider = FutureProvider.family<void, Map<String, dynamic>>(
    (ref, data) async {
      // Log incoming map for debugging missing punch_in_time issues
      print('▶️ punchInProvider invoked with data: $data');
      final bool isSupervisor = (data['supervisor_id'] != null) ||
          (data['is_supervisor'] == true) ||
          (data['isSupervisor'] == true);

      final punchInTime = data['punch_in_time'] ?? '';
      if (punchInTime == null || (punchInTime is String && punchInTime.trim().isEmpty)) {
        print('⚠️ punchInProvider: punch_in_time missing or empty in provided data');
      }

      print('   -> calling AuthService.punchIn (project_id: ${data['project_id']}, punch_in_time: $punchInTime)');
      await AuthService.punchIn(
        labourId: data['labour_id'],
        supervisorId: data['supervisor_id'],
        projectId: data['project_id'],
        punchInTime: punchInTime,
        isSupervisor: isSupervisor,
      );
      print('◀️ punchInProvider completed for project_id: ${data['project_id']}');
    },
  );

  /// ---------------------------
  /// 🔹 MANUAL PUNCH OUT FUNCTION PROVIDER (optional helper)
  /// ---------------------------
  final punchOutProvider = FutureProvider.family<void, Map<String, dynamic>>(
    (ref, data) async {
      print('▶️ punchOutProvider invoked with data: $data');
      final bool isSupervisor = (data['supervisor_id'] != null) ||
          (data['is_supervisor'] == true) ||
          (data['isSupervisor'] == true);

      final punchOutTime = data['punch_out_time'] ?? '';
      if (punchOutTime == null || (punchOutTime is String && punchOutTime.trim().isEmpty)) {
        print('⚠️ punchOutProvider: punch_out_time missing or empty in provided data');
      }

      print('   -> calling AuthService.punchOut (attendance_id: ${data['attendance_id']}, punch_out_time: $punchOutTime)');
      await AuthService.punchOut(
        attendanceId: data['attendance_id'],
        punchOutTime: punchOutTime,
        labourId: data['labour_id'],
        supervisorId: data['supervisor_id'],
        projectId: data['project_id'],
        isSupervisor: isSupervisor,
      );
      print('◀️ punchOutProvider completed for attendance_id: ${data['attendance_id']}');
    },
  );
}
