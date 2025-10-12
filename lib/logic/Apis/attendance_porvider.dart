import 'package:contractor_app/logic/Apis/apis.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

final attendanceProvider =
    StateNotifierProvider<AttendanceNotifier, AttendanceState>(
  (ref) => AttendanceNotifier(),
);

class AttendanceState {
  final bool isLoading;
  final bool isPunchedIn;
  final int? projectId;
  final int? attendanceId;
  final String? error;

  AttendanceState({
    this.isLoading = false,
    this.isPunchedIn = false,
    this.projectId,
    this.attendanceId,
    this.error,
  });

  AttendanceState copyWith({
    bool? isLoading,
    bool? isPunchedIn,
    int? projectId,
    int? attendanceId,
    String? error,
  }) {
    return AttendanceState(
      isLoading: isLoading ?? this.isLoading,
      isPunchedIn: isPunchedIn ?? this.isPunchedIn,
      projectId: projectId ?? this.projectId,
      attendanceId: attendanceId ?? this.attendanceId,
      error: error ?? this.error,
    );
  }
}

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  AttendanceNotifier() : super(AttendanceState()) {
    _loadSavedState();
  }

  Future<void> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    final projectIdDynamic = prefs.get('projectId');
    int? projectId;
    if (projectIdDynamic is String) {
      projectId = int.tryParse(projectIdDynamic);
    } else if (projectIdDynamic is int) {
      projectId = projectIdDynamic;
    }

    state = state.copyWith(
      isPunchedIn: prefs.getBool('isPunchedIn') ?? false,
      projectId: projectId,
      attendanceId: prefs.getInt('attendanceId'),
    );
  }

  Future<void> punchIn(int labourId, int projectId) async {
    try {
      state = state.copyWith(isLoading: true);
      final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      final res = await AuthService.punchIn(
        labourId: labourId,
        projectId: projectId,
        punchInTime: now,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isPunchedIn', true);
      await prefs.setInt('projectId', projectId);
      await prefs.setInt('attendanceId', res.attendance?.id ?? 0);

      state = state.copyWith(
        isLoading: false,
        isPunchedIn: true,
        projectId: projectId,
        attendanceId: res.attendance?.id,
      );

      print("🕒 Punch-In at $now");
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> punchOut(int labourId, int projectId) async {
    try {
      state = state.copyWith(isLoading: true);
      final prefs = await SharedPreferences.getInstance();
      final attendanceId = prefs.getInt('attendanceId');
      if (attendanceId == null) throw Exception("No active attendance ID");

      final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      await AuthService.punchOut(
        attendanceId: attendanceId,
        punchOutTime: now,
        labourId: labourId,
        projectId: projectId,
      );

      await prefs.clear();

      state = AttendanceState(isLoading: false);
      print("🕒 Punch-Out at $now");
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
