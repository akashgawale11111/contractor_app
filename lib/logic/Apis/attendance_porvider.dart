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
  final bool isSupervisor;

  AttendanceState({
    this.isLoading = false,
    this.isPunchedIn = false,
    this.projectId,
    this.attendanceId,
    this.error,
    this.isSupervisor = false,
  });

  AttendanceState copyWith({
    bool? isLoading,
    bool? isPunchedIn,
    int? projectId,
    int? attendanceId,
    String? error,
    bool? isSupervisor,
  }) {
    return AttendanceState(
      isLoading: isLoading ?? this.isLoading,
      isPunchedIn: isPunchedIn ?? this.isPunchedIn,
      projectId: projectId ?? this.projectId,
      attendanceId: attendanceId ?? this.attendanceId,
      error: error ?? this.error,
      isSupervisor: isSupervisor ?? this.isSupervisor,
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
      isSupervisor: prefs.getBool('isSupervisor') ?? false,
    );
  }

  Future<void> punchIn({
    int? labourId,
    int? supervisorId,
    String? supervisorLoginId,
    required int projectId,
    required bool isSupervisor,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      // Debug: log the local time we will send
      print('====================================================');
      print('▶️ AttendanceNotifier.punchIn called');
      print('  labourId: ${labourId ?? 'null'}');
      print('  supervisorId: ${supervisorId ?? 'null'}');
      print('  projectId: $projectId');
      print('  isSupervisor: $isSupervisor');
      print('  local_punch_in_time: $now');

      final res = await AuthService.punchIn(
        labourId: labourId,
        supervisorId: supervisorId,
        supervisorLoginId: supervisorLoginId,
        projectId: projectId,
        punchInTime: now,
        isSupervisor: isSupervisor,
      );
      print('◀️ AttendanceNotifier.punchIn returned');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isPunchedIn', true);
      await prefs.setInt('projectId', projectId);
      if (res.attendance.id != null) {
        await prefs.setInt('attendanceId', res.attendance.id!);
      }
      await prefs.setBool('isSupervisor', isSupervisor);

      state = state.copyWith(
        isLoading: false,
        isPunchedIn: true,
        projectId: projectId,
  attendanceId: res.attendance.id,
        isSupervisor: isSupervisor,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> punchOut({
    int? labourId,
    int? supervisorId,
    required int projectId,
    required bool isSupervisor,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      final prefs = await SharedPreferences.getInstance();
      final attendanceId = prefs.getInt('attendanceId');
      if (attendanceId == null) throw Exception("No active attendance ID");

      final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      // Debug: log the local time and attendance id we'll send
      print('====================================================');
      print('▶️ AttendanceNotifier.punchOut called');
      print('  attendanceId: $attendanceId');
      print('  labourId: ${labourId ?? 'null'}');
      print('  supervisorId: ${supervisorId ?? 'null'}');
      print('  projectId: $projectId');
      print('  isSupervisor: $isSupervisor');
      print('  local_punch_out_time: $now');

      await AuthService.punchOut(
        attendanceId: attendanceId,
        punchOutTime: now,
        labourId: labourId,
        supervisorId: supervisorId,
        projectId: projectId,
        isSupervisor: isSupervisor,
      );

      print('◀️ AttendanceNotifier.punchOut completed');

      // Remove only attendance-related keys to avoid clearing other stored data
      await prefs.remove('isPunchedIn');
      await prefs.remove('projectId');
      await prefs.remove('attendanceId');
      await prefs.remove('isSupervisor');

      state = AttendanceState(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
