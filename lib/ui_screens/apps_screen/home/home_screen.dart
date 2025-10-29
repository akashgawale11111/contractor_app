import 'dart:convert';
import 'dart:io';
import 'package:aws_client/rekognition_2016_06_27.dart' as aws;
import 'package:collection/collection.dart';
import 'package:contractor_app/logic/Apis/attendance_porvider.dart';
import 'package:contractor_app/logic/providers.dart';
import 'package:contractor_app/logic/Apis/provider.dart';
import 'package:contractor_app/utils/custom_Widgets/custom_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// ---------------------- MODEL ----------------------

class ProjectModel {
  final List<TotalProjects>? totalProjects;
  ProjectModel({this.totalProjects});

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      totalProjects: json['total_projects'] != null
          ? (json['total_projects'] as List)
              .map((v) => TotalProjects.fromJson(v))
              .toList()
          : [],
    );
  }
}

class TotalProjects {
  final String? id;
  final String? name;
  final String? address;
  final String? city;
  final String? state;
  final String? projectImageUrl;
  final double? latitude;
  final double? longitude;

  TotalProjects({
    this.id,
    this.name,
    this.address,
    this.city,
    this.state,
    this.projectImageUrl,
    this.latitude,
    this.longitude,
  });

  static List<double>? _parseLatLng(String? location) {
    if (location == null) return null;
    try {
      final parts = location.split(',');
      if (parts.length == 2) {
        final lat = double.tryParse(parts[0].trim());
        final lng = double.tryParse(parts[1].trim());
        if (lat != null && lng != null) return [lat, lng];
      }
    } catch (_) {}
    return null;
  }

  factory TotalProjects.fromJson(Map<String, dynamic> json) {
    final coords = _parseLatLng(json['location']);
    return TotalProjects(
      id: json['id']?.toString(),
      name: json['name'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      projectImageUrl: json['image_url'],
      latitude: coords != null ? coords[0] : null,
      longitude: coords != null ? coords[1] : null,
    );
  }
}

// ---------------------- PROVIDER ----------------------

final projectListProvider = FutureProvider<ProjectModel>((ref) async {
  final url = Uri.parse("https://admin.mmprecise.com/api/getallprojects");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return ProjectModel.fromJson(json.decode(response.body));
  } else {
    throw Exception("Failed to fetch projects");
  }
});

// ---------------------- HOME SCREEN ----------------------

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final projectsAsync = ref.watch(projectListProvider);
    final punchState = ref.watch(punchStateProvider);

    return Scaffold(
      body: projectsAsync.when(
        data: (projectModel) {
          final projects = projectModel.totalProjects ?? [];
          if (projects.isEmpty) {
            return const Center(child: Text("No projects available"));
          }

          if (punchState['isPunchedIn']) {
            final punchedInProject = projects.firstWhereOrNull(
                (p) => p.id.toString() == punchState['projectId'].toString());
            if (punchedInProject == null) {
              return const Center(child: Text("Punched-in project not found"));
            }

            final sortedProjects = projects.toList();
            sortedProjects.sort((a, b) {
              if (a.id.toString() == punchState['projectId'].toString()) {
                return -1;
              }
              if (b.id.toString() == punchState['projectId'].toString()) {
                return 1;
              }
              return 0;
            });

            return _buildProjectList(sortedProjects, punchState, width);
          } else {
            return _buildProjectList(projects, punchState, width);
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
      ),
    );
  }

  Widget _buildProjectList(List<TotalProjects> projects,
      Map<String, dynamic> punchState, double width) {
    return ListView.builder(
      padding: EdgeInsets.all(width * 0.03),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return _buildProjectCard(context, project, punchState);
      },
    );
  }

  Widget _buildProjectCard(BuildContext context, TotalProjects project,
      Map<String, dynamic> punchState) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isThisProjectPunchedIn = punchState['isPunchedIn'] &&
        punchState['projectId'].toString() == project.id.toString();

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.02),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(width * 0.028),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              project.projectImageUrl != null
                  ? Image.network(
                      project.projectImageUrl!,
                      width: width * 0.25,
                      height: height * 0.16,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) =>
                          const Icon(Icons.broken_image, size: 60),
                    )
                  : Image.asset(
                      'assets/images/Elevation1.png',
                      width: width * 0.25,
                      height: height * 0.16,
                      fit: BoxFit.cover,
                    ),
              SizedBox(width: width * 0.035),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.name ?? "Untitled Project",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange)),
                    const SizedBox(height: 8),
                    Text(project.address ?? "No Address"),
                    Text(project.city ?? "No City"),
                    Text(project.state ?? "No State"),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (isThisProjectPunchedIn)
                          Expanded(
                            child: GradientButton(
                              text: "Punch Out",
                              onPressed: () => _navigateToMapScreen(
                                  context, project, 'punch_out'),
                              colors: const [
                                Color(0xFFFF4B2B),
                                Color(0xFFFF416C)
                              ], // red-pink gradient
                            ),
                          )
                        else if (!punchState['isPunchedIn'])
                          Expanded(
                            child: GradientButton(
                              text: "Punch In",
                              onPressed: () => _navigateToMapScreen(
                                  context, project, 'punch_in'),
                              colors: const [
                                Color(0xFF00B09B),
                                Color(0xFF96C93D)
                              ], // green gradient
                            ),
                          )
                        else if (punchState['isPunchedIn'] &&
                            !isThisProjectPunchedIn)
                          Expanded(
                            child: GradientButton(
                              text: "Punch In",
                              onPressed: null, // disabled
                              colors: const [Colors.grey, Colors.grey],
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToMapScreen(
      BuildContext context, TotalProjects project, String action) {
    if (project.latitude == null || project.longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid project coordinates")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapScreenWithPunch(
          project: project,
          action: action,
        ),
      ),
    );
  }
}

// ---------------------- MAP SCREEN WITH ROUTE + PUNCH ----------------------

class MapScreenWithPunch extends StatefulWidget {
  final TotalProjects project;
  final String action;
  const MapScreenWithPunch({
    super.key,
    required this.project,
    required this.action,
  });

  @override
  State<MapScreenWithPunch> createState() => _MapScreenWithPunchState();
}

class _MapScreenWithPunchState extends State<MapScreenWithPunch>
    with WidgetsBindingObserver {
  Position? _currentPosition;
  double? _distance;
  Set<Polyline> _polylines = {};
  late LatLng _projectLatLng;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _projectLatLng =
        LatLng(widget.project.latitude!, widget.project.longitude!);
    _getCurrentLocation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _getCurrentLocation();
    }
  }

  Future<void> _showGPSDisabledDialog() async {
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("GPS is Disabled"),
          content: const Text("Please turn on GPS to continue."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openLocationSettings();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        _showGPSDisabledDialog();
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
    }

    final position = await Geolocator.getCurrentPosition();

    final double calculatedDistance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      widget.project.latitude!,
      widget.project.longitude!,
    );

    if (mounted) {
      setState(() {
        _currentPosition = position;
        _distance = calculatedDistance;
      });
    }

    if (calculatedDistance >= 200) {
      if (mounted) {
        setState(() {
          _polylines = {
            Polyline(
              polylineId: const PolylineId('route'),
              points: [
                LatLng(position.latitude, position.longitude),
                _projectLatLng,
              ],
              color: Colors.blue,
              width: 5,
            ),
          };
        });
      }
    }

    // ✅ Auto navigate to Face Compare if near project
    if (calculatedDistance < 200) {
      Future.delayed(const Duration(seconds: 7), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => FaceCompareAWS(
                projectId: widget.project.id!,
                action: widget.action,
              ),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.project.name ?? "Project Location",
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _projectLatLng,
                    zoom: 16,
                  ),
                  polylines: _polylines,
                  markers: {
                    Marker(
                      markerId: const MarkerId('project'),
                      position: _projectLatLng,
                      infoWindow: InfoWindow(title: widget.project.name),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed),
                    ),
                    if (_currentPosition != null)
                      Marker(
                        markerId: const MarkerId('user'),
                        position: LatLng(_currentPosition!.latitude,
                            _currentPosition!.longitude),
                        infoWindow: const InfoWindow(title: 'Your Location'),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueBlue),
                      ),
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                ),
                if (_distance != null && _distance! >= 200)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Card(
                      elevation: 5,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          "📍 Distance to project: ${_distance!.toStringAsFixed(2)} meters",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

// -------------------- FaceCompareAWS --------------------
class FaceCompareAWS extends ConsumerStatefulWidget {
  final String projectId;
  final String action;
  const FaceCompareAWS({
    super.key,
    required this.projectId,
    required this.action,
  });

  @override
  ConsumerState<FaceCompareAWS> createState() => _FaceCompareAWSState();
}

class _FaceCompareAWSState extends ConsumerState<FaceCompareAWS> {
  File? _selfieImage;
  bool _isComparing = false;
  late final aws.Rekognition rekognition;

  @override
  void initState() {
    super.initState();
    // AWS Rekognition setup
    rekognition = aws.Rekognition(
      region: "ap-south-1",
      credentials: aws.AwsClientCredentials(
        accessKey:
            "AKIAQTXFPFMNBGZN7NVV", // ⚠️ Replace with env var or secret manager
        secretKey: "lay+TFsjjZmcG8wOquekqM9u2WcmVICVwmODket7",
      ),
    );
  }

  // -------------------- Face Compare + Punch --------------------
  Future<void> _takeSelfieAndCompare(
      String labourImageUrl, String name, int labourId) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked == null) return;

    _selfieImage = File(picked.path);
    setState(() => _isComparing = true);

    try {
      final selfieBytes = await _selfieImage!.readAsBytes();
      final networkImage = await http.get(Uri.parse(labourImageUrl));

      if (networkImage.statusCode != 200) {
        _showErrorDialog("Failed to load labour image.");
        return;
      }

      final response = await rekognition.compareFaces(
        sourceImage: aws.Image(bytes: selfieBytes),
        targetImage: aws.Image(bytes: networkImage.bodyBytes),
        similarityThreshold: 80,
      );

      final match = response.faceMatches?.firstOrNull;

      if (match != null && match.similarity != null) {
        await _handleSuccessfulMatch(labourId);
      } else {
        _showErrorDialog("Face does not match.");
      }
    } catch (e) {
      _showErrorDialog(
          "An error occurred during face comparison: ${e.toString()}");
    } finally {
      setState(() => _isComparing = false);
    }
  }

  Future<void> _handleSuccessfulMatch(int labourId) async {
    final notifier = ref.read(attendanceProvider.notifier);
    final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    try {
      if (widget.action == 'punch_in') {
        await notifier.punchIn(labourId, int.parse(widget.projectId));
        ref
            .read(punchStateProvider.notifier)
            .punchIn(int.parse(widget.projectId));
        if (!mounted) return;
        await _showSuccessPopup(
          "Punched In Successfully!",
          action: widget.action,
          imageFile: _selfieImage,
          punchTime: now,
        );
      } else {
        await notifier.punchOut(labourId, int.parse(widget.projectId));
        ref.read(punchStateProvider.notifier).punchOut();
        if (!mounted) return;
        await _showSuccessPopup(
          "Punched Out Successfully!",
          action: widget.action,
          imageFile: _selfieImage,
          punchTime: now,
        );
      }

      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog("Failed to ${widget.action}: ${e.toString()}");
    }
  }

  // -------------------- UI Helpers --------------------
  Future<void> _showSuccessPopup(String message,
      {required String action,
      required File? imageFile,
      required String punchTime}) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              action == 'punch_in'
                  ? "Punch In Successful"
                  : "Punch Out Successful",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  imageFile,
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Text(
              "Time: $punchTime",
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
        actions: [
          // TextButton(
          //   onPressed: () => Navigator.of(context).pop(),
          //   child:
          //       const Text("OK", style: TextStyle(fontWeight: FontWeight.bold)),
          // ),
          CustomButton(
            onPressed: () => Navigator.of(context).pop(),
            text: "OK",
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          // TextButton(
          //   onPressed: () => Navigator.pop(context),
          //   child: const Text("OK"),
          // )
          CustomButton(
            onPressed: () => Navigator.of(context).pop(),
            text: "OK",
          )
        ],
      ),
    );
  }

  // -------------------- UI --------------------
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    if (user == null || user.labour == null) {
      return const Scaffold(body: Center(child: Text("No user data")));
    }
    final labour = user.labour!;
    final labourId = int.tryParse(labour.id?.toString() ?? '');
    if (labourId == null) {
      return const Scaffold(body: Center(child: Text("Invalid user ID")));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Location",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              // Circular mask style similar to screenshot
              ClipOval(
                child: _selfieImage != null
                    ? Image.file(
                        _selfieImage!,
                        height: 350,
                        width: 350,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 350,
                        width: 350,
                        color: Colors.black.withAlpha(25),
                        child: const Icon(Icons.person,
                            size: 80, color: Colors.grey),
                      ),
              ),
              if (_isComparing)
                const Positioned.fill(
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            "Center Your Face",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Align You Face To The Center Of The Selfie Area And\nThen Take Photo",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 50),
          if (!_isComparing)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.flash_on, color: Colors.black54),
                  onPressed: () {},
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () => _takeSelfieAndCompare(labour.imageUrl!,
                      "${labour.firstName!} ${labour.lastName!}", labourId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(24),
                    elevation: 5,
                  ),
                  child: const Icon(Icons.camera_alt,
                      size: 36, color: Colors.black87),
                ),
                const SizedBox(width: 30),
                IconButton(
                  icon: const Icon(Icons.cameraswitch, color: Colors.black54),
                  onPressed: () {},
                ),
              ],
            ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
