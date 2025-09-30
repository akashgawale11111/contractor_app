import 'dart:io';
import 'package:contractor_app/logic/Apis/provider.dart';
import 'package:contractor_app/ui_screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:aws_client/rekognition_2016_06_27.dart' as aws;
import 'package:intl/intl.dart';

class FaceCompareAWS extends ConsumerStatefulWidget {
  const FaceCompareAWS({super.key});

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
    rekognition = aws.Rekognition(
      region: "ap-south-1",
      credentials: aws.AwsClientCredentials(
        accessKey: "AKIAQTXFPFMNBGZN7NVV", // Replace with secure env values
        secretKey: "lay+TFsjjZmcG8wOquekqM9u2WcmVICVwmODket7",
      ),
    );
  }

  Future<void> _takeSelfieAndCompare(String labourImageUrl, String name) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked == null) return;

    _selfieImage = File(picked.path);
    setState(() => _isComparing = true);

    try {
      final selfieBytes = await _selfieImage!.readAsBytes();
      final networkImage = await http.get(Uri.parse(labourImageUrl));

      if (networkImage.statusCode != 200) {
        throw Exception("Failed to load labour image.");
      }

      final response = await rekognition.compareFaces(
        sourceImage: aws.Image(bytes: selfieBytes),
        targetImage: aws.Image(bytes: networkImage.bodyBytes),
        similarityThreshold: 80,
      );

      final match = response.faceMatches?.firstOrNull;

      if (match != null && match.similarity != null) {
        _showSuccessPopup(name, _selfieImage!);
      } else {
        _showErrorDialog("Face does not match.");
      }
    } catch (e) {
      _showErrorDialog("Error: ${e.toString()}");
    } finally {
      setState(() => _isComparing = false);
    }
  }

  void _showSuccessPopup(String name, File selfieImage) {
    final punchTime = DateFormat.jm().format(DateTime.now());

    // Get the action type from route settings
    final actionType =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'punch_in';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "You Have Successfully ${actionType == 'punch_in' ? 'Punched In' : 'Punched Out'}.",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            CircleAvatar(
              radius: 40,
              backgroundImage: FileImage(selfieImage),
            ),
            const SizedBox(height: 12),
            Text("Name: $name",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
                "${actionType == 'punch_in' ? 'Punch In' : 'Punch Out'} Time: $punchTime",
                style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                    settings: RouteSettings(arguments: {
                      'isPunchedIn': actionType == 'punch_in',
                      'isPunchedOut': actionType == 'punch_out',
                    }),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text("Done", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Face Match Failed"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final labour = ref.watch(labourProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Location")),
      body: Column(
        children: [
          const SizedBox(height: 16),
          if (_selfieImage == null) ...[
            const Center(
              child: Text(
                "Center Your Face",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                "Align your face to the center of the selfie area and then take photo",
                textAlign: TextAlign.center,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Expanded(
            child: Center(
              child: CircleAvatar(
                radius: 100,
                backgroundImage:
                    _selfieImage != null ? FileImage(_selfieImage!) : null,
                child: _selfieImage == null
                    ? const Icon(Icons.camera_alt, size: 50)
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (_isComparing)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.flash_on),
                  onPressed: () {}, // Optional: Flash toggle logic
                ),
                ElevatedButton(
                  onPressed: (labour?.imageUrl != null && labour?.email != null)
                      ? () => _takeSelfieAndCompare(
                            labour!.imageUrl!,
                            labour.email!,
                          )
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Icon(Icons.camera, size: 30),
                ),
                IconButton(
                  icon: const Icon(Icons.cameraswitch),
                  onPressed: () {}, // Optional: Switch camera logic
                ),
              ],
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
