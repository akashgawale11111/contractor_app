// import 'dart:io';
// import 'package:contractor_app/logic/Apis/provider.dart';
// import 'package:contractor_app/ui_screens/apps_screen/navbar.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:aws_client/rekognition_2016_06_27.dart' as aws;

// // -------------------- FaceCompareAWS --------------------
// class FaceCompareAWS extends ConsumerStatefulWidget {
//   const FaceCompareAWS({super.key});

//   @override
//   ConsumerState<FaceCompareAWS> createState() => _FaceCompareAWSState();
// }

// class _FaceCompareAWSState extends ConsumerState<FaceCompareAWS> {
//   File? _selfieImage;
//   bool _isComparing = false;

//   late final aws.Rekognition rekognition;

//   @override
//   void initState() {
//     super.initState();
//     // WARNING: Hardcoded credentials.
//     rekognition = aws.Rekognition(
//       region: "ap-south-1",
//       credentials: aws.AwsClientCredentials(
//         accessKey: "AKIAQTXFPFMNBGZN7NVV",
//         secretKey: "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",
//       ),
//     );
//   }

//   Future<void> _takeSelfieAndCompare(String labourImageUrl, String name) async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.camera);
//     if (picked == null) return;

//     _selfieImage = File(picked.path);
//     setState(() => _isComparing = true);

//     try {
//       final selfieBytes = await _selfieImage!.readAsBytes();
//       final networkImage = await http.get(Uri.parse(labourImageUrl));

//       if (networkImage.statusCode != 200) {
//         throw Exception("Failed to load labour image.");
//       }

//       final response = await rekognition.compareFaces(
//         sourceImage: aws.Image(bytes: selfieBytes),
//         targetImage: aws.Image(bytes: networkImage.bodyBytes),
//         similarityThreshold: 80,
//       );

//       final match = response.faceMatches?.firstOrNull;

//       if (match != null && match.similarity != null) {
//         final args =
//             ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
//         final action = args?['action'] as String? ?? 'punch_in';

//         await _showSuccessPopup(action);
//         Navigator.of(context).pop(true); // Pop with true result
//       } else {
//         _showErrorDialog("Face does not match.");
//       }
//     } catch (e) {
//       _showErrorDialog("Error: ${e.toString()}");
//     } finally {
//       setState(() => _isComparing = false);
//     }
//   }

//   Future<void> _showSuccessPopup(String action) async {
//     await showDialog(
//       context: context, // No need to show a popup here, it's handled in home_screen
//       builder: (_) => AlertDialog( // This will be removed, but keeping it simple for now.
//         title: const Text("Success"), // The home screen will show the final popup.
//         content: Text("Face Verified!"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(), // Just pop the dialog
//             child: const Text("OK"),
//           )
//         ],
//       ),
//     );
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Face Match Failed"),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("OK"),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = ref.watch(authProvider);

//     if (user == null || user.labour == null) {
//       return const Scaffold(
//         body: Center(child: Text("No user data")),
//       );
//     }

//     final labour = user.labour!;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Face Verification")),
//       body: Column(
//         children: [
//           const SizedBox(height: 16),
//           if (_selfieImage == null) ...[
//             const Center(
//               child: Text(
//                 "Center Your Face",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//               child: Text(
//                 "Align your face to the center and take a photo",
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ],
//           const SizedBox(height: 10),
//           Expanded(
//             child: Center(
//               child: CircleAvatar(
//                 radius: 100,
//                 backgroundImage:
//                     _selfieImage != null ? FileImage(_selfieImage!) : null,
//                 child: _selfieImage == null
//                     ? const Icon(Icons.camera_alt, size: 50)
//                     : null,
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           if (_isComparing)
//             const Padding(
//               padding: EdgeInsets.all(16),
//               child: CircularProgressIndicator(),
//             )
//           else
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.flash_on),
//                   onPressed: () {},
//                 ),
//                 ElevatedButton(
//                   onPressed: (labour.imageUrl != null && labour.email != null)
//                       ? () => _takeSelfieAndCompare(
//                             labour.imageUrl!,
//                             labour.email!,
//                           )
//                       : null,
//                   style: ElevatedButton.styleFrom(
//                     shape: const CircleBorder(),
//                     padding: const EdgeInsets.all(20),
//                   ),
//                   child: const Icon(Icons.camera, size: 30),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.cameraswitch),
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:contractor_app/logic/Apis/attendance_porvider.dart';
import 'package:contractor_app/logic/Apis/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:aws_client/rekognition_2016_06_27.dart' as aws;
import 'package:intl/intl.dart';

// -------------------- FaceCompareAWS --------------------
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
    // AWS Rekognition setup
    rekognition = aws.Rekognition(
      region: "ap-south-1",
      credentials: aws.AwsClientCredentials(
        accessKey: "AKIAQTXFPFMNBGZN7NVV", // ⚠️ Replace with env var or secret manager
        secretKey: "lay+TFsjjZmcG8wOquekqM9u2WcmVICVwmODket7",
      ),
    );
  }

  // -------------------- Face Compare + Punch --------------------
  Future<void> _takeSelfieAndCompare(String labourImageUrl, String name, int labourId, int projectId) async {
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
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
        final action = args['action'] as String? ?? 'punch_in';

        final notifier = ref.read(attendanceProvider.notifier);
        final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

        if (action == 'punch_in') {
          await notifier.punchIn(labourId, projectId);
          await _showSuccessPopup("Punched In at $now");
        } else {
          await notifier.punchOut(labourId, projectId);
          await _showSuccessPopup("Punched Out at $now");
        }

        Navigator.of(context).pop(true); // Pop back to home
      } else {
        _showErrorDialog("Face does not match.");
      }
    } catch (e) {
      _showErrorDialog("Error: ${e.toString()}");
    } finally {
      setState(() => _isComparing = false);
    }
  }

  // -------------------- UI Helpers --------------------
  Future<void> _showSuccessPopup(String message) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Success"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          )
        ],
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

  // -------------------- UI --------------------
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    if (user == null || user.labour == null) {
      return const Scaffold(body: Center(child: Text("No user data")));
    }
    final labour = user.labour!;
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final projectId = int.tryParse(args['projectId']?.toString() ?? '0') ?? 0;
    final labourId = int.tryParse(labour.id?.toString() ?? '0') ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text("Face Verification")),
      body: Column(
        children: [
          const SizedBox(height: 16),
          if (_selfieImage == null) ...[
            const Center(
              child: Text("Center Your Face",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                "Align your face to the center and take a photo",
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
                IconButton(icon: const Icon(Icons.flash_on), onPressed: () {}),
                ElevatedButton(
                  onPressed: (labour.imageUrl != null)
                      ? () => _takeSelfieAndCompare(
                            labour.imageUrl!,
                            labour.email ?? '',
                            labourId,
                            projectId,
                          )
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Icon(Icons.camera, size: 30),
                ),
                IconButton(icon: const Icon(Icons.cameraswitch), onPressed: () {}),
              ],
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
