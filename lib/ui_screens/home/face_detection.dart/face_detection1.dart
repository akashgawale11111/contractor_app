import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path; // ✅ FIX: Avoids context conflict

List<CameraDescription> cameras = [];

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  bool isCameraInitialized = false;
  XFile? capturedImage;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  void initCamera() async {
    try {
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      controller = CameraController(frontCamera, ResolutionPreset.medium);
      await controller!.initialize();

      if (!mounted) return;
      setState(() {
        isCameraInitialized = true;
      });
    } catch (e) {
      print("Camera initialization error: $e");
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> takePicture() async {
    try {
      if (!controller!.value.isInitialized) return;

      final XFile image = await controller!.takePicture();
      setState(() {
        capturedImage = image;
      });

      showDialog(
        context: context,
        builder: (_) => PunchInDialog(imagePath: image.path),
      );
    } catch (e) {
      print("Error taking picture: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to take picture")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: isCameraInitialized
          ? Column(
              children: [
                Expanded(
                  child: Center(
                    child: ClipOval(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: CameraPreview(controller!),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Center Your Face",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  child: Text(
                    "Align your face to the center of the selfie area and then take photo",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flash_off, color: Colors.grey),
                    SizedBox(width: 30),
                    GestureDetector(
                      onTap: takePicture,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.camera_alt, size: 30, color: Colors.black),
                      ),
                    ),
                    SizedBox(width: 30),
                    Icon(Icons.cameraswitch, color: Colors.grey),
                  ],
                ),
                SizedBox(height: 30),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class PunchInDialog extends StatelessWidget {
  final String imagePath;

  const PunchInDialog({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final timeNow = TimeOfDay.now().format(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: EdgeInsets.all(16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "You Have Successfully Punched In.",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ClipOval(
            child: Image.file(
              File(imagePath),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Name: Ramesh Kumar",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text("Punch In Time: $timeNow"),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              minimumSize: Size(double.infinity, 40),
            ),
            child: Text("Done"),
          ),
        ],
      ),
    );
  }
}
