import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:contractor_app/ui_screens/apps_screen/home/verificationScreen/face_detection/aws_facerecognition.dart';

/// Merged Location and Map Screen with Riverpod
class LocationMapScreen extends ConsumerStatefulWidget {
  const LocationMapScreen({super.key});

  @override
  ConsumerState<LocationMapScreen> createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends ConsumerState<LocationMapScreen> {
  gmaps.LatLng? _currentLatLng;
  String _address = "Fetching address...";
  String _dateTime = ""; 
  gmaps.GoogleMapController? _mapController;
  gmaps.CameraPosition? _initialCameraPosition;
  bool _isLoading = true;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  /// Initialize location with all checks
  Future<void> _initializeLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      // Check GPS
      bool gpsEnabled = await _checkGPS();
      if (!gpsEnabled) {
        setState(() {
          _isLoading = false;
          _errorMessage = "GPS is required for this feature";
        });
        return;
      }

      // Check location permission
      var permissionStatus = await Permission.location.request();
      if (!permissionStatus.isGranted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Location permission is required";
        });
        _showPermissionDialog();
        return;
      }

      // Check internet connection
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Internet connection is required";
        });
        _showInternetDialog();
        return;
      }

      // Fetch location
      await _getCurrentLocation();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to initialize location: $e";
      });
    }
  }

  Future<bool> _checkGPS() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return false;
      bool? result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Location Services Disabled'),
            content: const Text(
              'Please enable location services to use this feature. Would you like to open settings now?',
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () => Navigator.of(dialogContext).pop(false),
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () async {
                  Navigator.of(dialogContext).pop(true);
                  await Geolocator.openLocationSettings();
                },
              ),
            ],
          );
        },
      );

      if (result == true) {
        // Wait a bit for user to enable GPS
        await Future.delayed(const Duration(seconds: 2));
        return await Geolocator.isLocationServiceEnabled();
      }
      return false;
    }
    return true;
  }

  void _showPermissionDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Permission Required'),
          content: const Text('Location permission is required to use this feature.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Settings'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  void _showInternetDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please enable your internet connection to use this feature.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      gmaps.LatLng currentLatLng = gmaps.LatLng(position.latitude, position.longitude);

      // Get address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = "Unable to fetch address";
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        address = "${place.street}, ${place.locality}, ${place.administrativeArea} - ${place.postalCode}";
      }

      setState(() {
        _currentLatLng = currentLatLng;
        _address = address;
        _dateTime = DateTime.now().toLocal().toString().substring(0, 16);
        _initialCameraPosition = gmaps.CameraPosition(
          target: currentLatLng,
          zoom: 16,
        );
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching location: $e");
      setState(() {
        _address = "Unable to fetch location";
        _isLoading = false;
        _errorMessage = "Failed to get current location";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: const Text("Location", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_errorMessage.isNotEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_errorMessage, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _initializeLocation,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          else if (_currentLatLng != null)
            gmaps.GoogleMap(
              initialCameraPosition: _initialCameraPosition ??
                  const gmaps.CameraPosition(
                    target: gmaps.LatLng(20.5937, 78.9629),
                    zoom: 16,
                  ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (controller) => _mapController = controller,
            ),

          // Info Card
          if (!_isLoading && _errorMessage.isEmpty)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Get Direction",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.navigation, color: Colors.deepOrange),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(_address, style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 14, color: Colors.black54),
                        const SizedBox(width: 4),
                        Text(_dateTime, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Continue Button
          if (!_isLoading && _errorMessage.isEmpty)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  final args = ModalRoute.of(context)?.settings.arguments
                      as Map<String, dynamic>?;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FaceCompareAWS(),
                      // Pass arguments to the next screen
                      settings: RouteSettings(arguments: args),
                    ),
                  ).then((result) {
                    // If face verification was successful, pop back to home screen with success
                    if (result == true) {
                      Navigator.of(context).pop(true);
                    }
                  });
                },
                child: const Text(
                  "Save Location & Continue",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Provider for project data
final projectProvider = FutureProvider<ProjectModel>((ref) async {
  // Replace with actual API call
  // return await AuthService.fetchProjects();
  throw UnimplementedError('Implement project fetching');
});

/// Model class (placeholder)
class ProjectModel {
  final List<Project>? totalProjects;

  ProjectModel({this.totalProjects});
}

class Project {
  final String? location;

  Project({this.location});
}
