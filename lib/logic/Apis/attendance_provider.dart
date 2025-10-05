import 'package:contractor_app/logic/Apis/apis.dart';
import 'package:contractor_app/logic/Apis/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

final attendanceProvider =
    StateNotifierProvider<AttendanceNotifier, AttendanceState>((ref) {
      // Pass ref to the notifier to access other providers
      return AttendanceNotifier(ref);
    });

class AttendanceState {
  final String location;
  final String time;
  final bool isLoading;
  final String? error;
  final bool isPunchedIn;
  final int? punchedInProjectId;

  AttendanceState({
    this.location = 'Unknown',
    this.time = 'Unknown',
    this.isLoading = false,
    this.error,
    this.isPunchedIn = false,
    this.punchedInProjectId,
  });

  AttendanceState copyWith({
    String? location,
    String? time,
    bool? isLoading,
    String? error,
    bool? isPunchedIn,
    int? punchedInProjectId,
    bool clearError = false,
  }) {
    return AttendanceState(
      location: location ?? this.location,
      time: time ?? this.time,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      isPunchedIn: isPunchedIn ?? this.isPunchedIn,
      punchedInProjectId: punchedInProjectId ?? this.punchedInProjectId,
    );
  }
}

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  // Store the ref
  final Ref _ref;
  AttendanceNotifier(this._ref) : super(AttendanceState()) {
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    final prefs = await SharedPreferences.getInstance();
    final isPunchedIn = prefs.getBool('isPunchedIn') ?? false;
    final punchedInProjectId = prefs.getInt('punchedInProjectId');
    state = state.copyWith(
      isPunchedIn: isPunchedIn,
      punchedInProjectId: punchedInProjectId,
    );
  }

  Future<void> punchIn(int projectId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      // Get labourId from authProvider
      final user = _ref.read(authProvider);
      if (user?.labour?.id == null) {
        throw Exception("User not logged in or labour ID is missing.");
      }
      final labourId = user!.labour!.id!;

      // Format time for API: YYYY-MM-DD HH:MM:SS
      final punchInTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      // Call the API
      await AuthService.punchIn(
        labourId: labourId,
        projectId: projectId,
        punchInTime: punchInTime,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isPunchedIn', true);
      await prefs.setInt('punchedInProjectId', projectId);

      state = state.copyWith(
        location: 'N/A', // Location is handled by map screen
        time: punchInTime,
        isLoading: false,
        isPunchedIn: true,
        punchedInProjectId: projectId,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> punchOut() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      // Get labourId and projectId
      final user = _ref.read(authProvider);
      if (user?.labour?.id == null) {
        throw Exception("User not logged in or labour ID is missing.");
      }
      if (state.punchedInProjectId == null) {
        throw Exception("Cannot punch out, no project is punched in.");
      }
      final labourId = user!.labour!.id!;
      final projectId = state.punchedInProjectId!;

      final punchOutTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      // Call the API
      await AuthService.punchOut(
        labourId: labourId,
        projectId: projectId,
        punchOutTime: punchOutTime,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isPunchedIn');
      await prefs.remove('punchedInProjectId');

      state = state.copyWith(
        isLoading: false,
        isPunchedIn: false,
        punchedInProjectId: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
