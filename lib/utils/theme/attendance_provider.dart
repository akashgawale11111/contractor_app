import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

final attendanceProvider =
    StateNotifierProvider<AttendanceNotifier, AttendanceState>((ref) {
      return AttendanceNotifier();
    });

class AttendanceState {
  final String location;
  final String time;
  final bool isLoading;
  final String? error;

  AttendanceState({
    this.location = 'Unknown',
    this.time = 'Unknown',
    this.isLoading = false,
    this.error,
  });

  AttendanceState copyWith({
    String? location,
    String? time,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return AttendanceState(
      location: location ?? this.location,
      time: time ?? this.time,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  AttendanceNotifier() : super(AttendanceState());

  Future<void> markAttendance() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _checkAndRequestGPS();
      Position position = await _getCurrentLocation();
      String place = await _getPlaceName(position.latitude, position.longitude);
      String currentTime = DateTime.now().toLocal().toString();

      state = state.copyWith(
        location: place,
        time: currentTime,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> _checkAndRequestGPS() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      // Give user time to enable GPS
      await Future.delayed(const Duration(seconds: 3));
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }
    }
  }

  Future<Position> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied. Please enable them in settings.',
      );
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String> _getPlaceName(double latitude, double longitude) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      latitude,
      longitude,
    );
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      List<String?> parts =
          [
            place.subThoroughfare,
            place.thoroughfare,
            place.subLocality,
            place.locality,
            place.administrativeArea,
            place.postalCode,
          ].where((part) => part != null && part.isNotEmpty).toList();
      return parts.join(', ');
    }
    return 'Unknown location';
  }
}
