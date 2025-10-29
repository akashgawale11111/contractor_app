import 'dart:convert';
import 'package:contractor_app/logic/Apis/apis.dart';
import 'package:contractor_app/logic/Apis/attendance_porvider.dart';
import 'package:contractor_app/logic/models/project_model.dart';
import 'package:contractor_app/logic/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      await AuthService.punchIn(
        labourId: data['labour_id'],
        projectId: data['project_id'],
        punchInTime: data['punch_in_time'],
      );
    },
  );

  /// ---------------------------
  /// 🔹 MANUAL PUNCH OUT FUNCTION PROVIDER (optional helper)
  /// ---------------------------
  final punchOutProvider = FutureProvider.family<void, Map<String, dynamic>>(
    (ref, data) async {
      await AuthService.punchOut(
        attendanceId: data['attendance_id'],
        punchOutTime: data['punch_out_time'],
        labourId: data['labour_id'],
        projectId: data['project_id'],
      );
    },
  );
}
