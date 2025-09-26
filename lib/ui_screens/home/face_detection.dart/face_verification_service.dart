// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';

// class FaceVerificationService {
//   // Singleton pattern
//   static final FaceVerificationService _instance = FaceVerificationService._internal();
//   factory FaceVerificationService() => _instance;
//   FaceVerificationService._internal();

//   final FaceDetector _faceDetector = FaceDetector(
//     options: FaceDetectorOptions(
//       enableTracking: true,
//       enableLandmarks: true,
//       enableClassification: true,
//       minFaceSize: 0.15,
//       performanceMode: FaceDetectorMode.accurate,
//     ),
//   );

//   // Load reference face from assets
//   Future<Uint8List?> _loadReferenceFace() async {
//     try {
//       final byteData = await rootBundle.load('assets/images/person1.jpeg');
//       return byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
//     } catch (e) {
//       debugPrint('Error loading reference face: $e');
//       return null;
//     }
//   }

//   // Save image to temp file for processing
//   Future<String> _saveImageToTemp(Uint8List imageBytes) async {
//     final directory = await getTemporaryDirectory();
//     final filePath = '${directory.path}/temp_face_${DateTime.now().millisecondsSinceEpoch}.jpg';
//     await File(filePath).writeAsBytes(imageBytes);
//     return filePath;
//   }

//   // Extract face features
//   Future<List<double>?> _extractFaceFeatures(Uint8List imageBytes) async {
//     try {
//       final inputImage = InputImage.fromBytes(bytes: imageBytes, metadata: InputImageMetadata(size: const Size(480, 640), rotation: InputImageRotation.rotation0deg, format: InputImageFormat.nv21, bytesPerRow: 0));
//       final faces = await _faceDetector.processImage(inputImage);
      
//       if (faces.isEmpty) return null;
      
//       // Use face landmarks as features
//       final face = faces.first;
//       final List<double> features = [
//         face.boundingBox.left,
//         face.boundingBox.top,
//         face.boundingBox.right,
//         face.boundingBox.bottom,
//       ];
      
//       return features;
//     } catch (e) {
//       debugPrint('Error extracting face features: $e');
//       return null;
//     }
//   }

//   // Compare two face feature vectors using Euclidean distance
//   double _compareFaces(List<double> features1, List<double> features2) {
//     if (features1.length != features2.length) return double.maxFinite;
    
//     double sumSquaredDiff = 0.0;
//     for (int i = 0; i < features1.length; i++) {
//       final diff = features1[i] - features2[i];
//       sumSquaredDiff += diff * diff;
//     }

//     // Return the Euclidean distance
//     return sumSquaredDiff > 0 ? (sumSquaredDiff / features1.length) : 0.0;
//   }

//   // Main verification method
//   Future<bool> verifyFace(Uint8List capturedImage) async {
//     try {
//       // Load reference face
//       final referenceImage = await _loadReferenceFace();
//       if (referenceImage == null) {
//         debugPrint('Failed to load reference face');
//         return false;
//       }
      
//       // Extract features from both images
//       final refFeatures = await _extractFaceFeatures(referenceImage);
//       final capturedFeatures = await _extractFaceFeatures(capturedImage);
      
//       if (refFeatures == null || capturedFeatures == null) {
//         debugPrint('Failed to extract face features');
//         return false;
//       }
      
//       // Compare features
//       final similarity = _compareFaces(refFeatures, capturedFeatures);
//       debugPrint('Face similarity score: $similarity');
      
//       // Consider it a match if similarity is below threshold (lower is better)
//       return similarity < 1000; // Adjust threshold as needed
//     } catch (e) {
//       debugPrint('Error in face verification: $e');
//       return false;
//     }
//   }

//   // Convert bytes to UI Image
//   static Future<ui.Image> bytesToImage(Uint8List bytes) async {
//     final Completer<ui.Image> completer = Completer();
//     ui.decodeImageFromList(bytes, (ui.Image img) {
//       completer.complete(img);
//     });
//     return completer.future;
//   }
// }

// // Custom painter to draw face rectangles
// class FacePainter extends CustomPainter {
//   final List<Face> faces;
//   final ui.Image image;

//   FacePainter(this.faces, this.image);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 3.0
//       ..color = Colors.green;

//     final scaleX = size.width / image.width;
//     final scaleY = size.height / image.height;

//     for (final face in faces) {
//       final boundingBox = face.boundingBox;
//       final left = boundingBox.left * scaleX;
//       final top = boundingBox.top * scaleY;
//       final right = boundingBox.right * scaleX;
//       final bottom = boundingBox.bottom * scaleY;
      
//       canvas.drawRect(
//         Rect.fromLTRB(left, top, right, bottom),
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(FacePainter oldDelegate) {
//     return true;
//   }
// }
