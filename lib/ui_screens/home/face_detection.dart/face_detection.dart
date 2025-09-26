// import 'dart:async';
// import 'dart:io';
// import 'package:contractor_app/ui_screens/home/face_detection.dart/face_verification_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart'; // Keep hooks
// // Add riverpod
// import 'package:camera/camera.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_fonts/google_fonts.dart';

// class FaceVerificationScreen extends HookConsumerWidget {
//   // Change to HookConsumerWidget
//   const FaceVerificationScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Add WidgetRef
//     final cameraController = useState<CameraController?>(null);
//     final isInitializing = useState(true);
//     final isProcessing = useState(false);
//     final cameras = useState<List<CameraDescription>>([]);
//     final selectedCameraIndex = useState(0);
//     final faceVerificationService = useMemoized(
//       () => FaceVerificationService(),
//     );

//     // Process image from device storage
//     Future<void> processStorageImage(bool mounted) async {
//       if (isProcessing.value) return;

//       isProcessing.value = true;
//       try {
//         final picker = ImagePicker();
//         final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//         if (pickedFile == null) {
//           isProcessing.value = false;
//           return;
//         }

//         debugPrint('Image picked from storage: ${pickedFile.path}');
//         final imageBytes = await pickedFile.readAsBytes();
//         debugPrint('Image size: ${imageBytes.length} bytes');

//         final isVerified = await faceVerificationService.verifyFace(imageBytes);
//         debugPrint('Face verification result from storage: $isVerified');

//         if (!mounted) return;

//         if (isVerified) {
//           Navigator.pop(context, true);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Face verification from storage failed.'),
//             ),
//           );
//         }
//       } catch (e, stackTrace) {
//         debugPrint('Error in processStorageImage: $e\n$stackTrace');
//       } finally {
//         if (mounted) isProcessing.value = false;
//       }
//     }

//     // Initialize camera
//     useEffect(() {
//       bool isMounted = true;

//       Future<void> initCamera() async {
//         try {
//           debugPrint('Initializing cameras...');
//           final availableCams = await availableCameras();
//           if (availableCams.isEmpty) {
//             throw Exception('No cameras found');
//           }
//           cameras.value = availableCams;

//           final frontCameraIndex = availableCams.indexWhere(
//             (c) => c.lensDirection == CameraLensDirection.front,
//           );
//           selectedCameraIndex.value =
//               (frontCameraIndex != -1) ? frontCameraIndex : 0;

//           final controller = CameraController(
//             cameras.value[selectedCameraIndex.value],
//             ResolutionPreset.medium,
//             enableAudio: false,
//             imageFormatGroup: ImageFormatGroup.yuv420,
//           );

//           await controller.initialize();

//           if (isMounted) {
//             debugPrint('Camera initialized successfully');
//             cameraController.value = controller;
//             isInitializing.value = false;
//           }
//         } catch (e, stackTrace) {
//           debugPrint('Error initializing camera: $e');
//           debugPrint('Stack trace: $stackTrace');
//           if (isMounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Error initializing camera: ${e.toString()}'),
//                 backgroundColor: Colors.red,
//               ),
//             );
//             Navigator.pop(context);
//           }
//         }
//       }

//       initCamera();

//       return () {
//         isMounted = false;
//         debugPrint('Disposing camera resources...');
//         cameraController.value?.dispose();
//       };
//     }, []);

//     // Function to switch camera
//     Future<void> switchCamera() async {
//       if (cameras.value.length < 2) return;

//       isInitializing.value = true;
//       await cameraController.value?.dispose();

//       final newIndex = (selectedCameraIndex.value + 1) % cameras.value.length;
//       selectedCameraIndex.value = newIndex;

//       final newController = CameraController(
//         cameras.value[newIndex],
//         ResolutionPreset.medium,
//         enableAudio: false,
//         imageFormatGroup: ImageFormatGroup.yuv420,
//       );

//       await newController.initialize();
//       cameraController.value = newController;
//       isInitializing.value = false;
//     }

//     if (isInitializing.value) {
//       return const Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(height: 16),
//               Text('Initializing camera...'),
//             ],
//           ),
//         ),
//       );
//     }

//     // Process camera frames
//     Future<void> captureAndVerify(bool mounted) async {
//       if (isProcessing.value) return;

//       isProcessing.value = true;
//       try {
//         final controller = cameraController.value;
//         if (controller == null || !controller.value.isInitialized) {
//           debugPrint('Camera controller not initialized');
//           return;
//         }

//         final image = await controller.takePicture();
//         final imageBytes = await File(image.path).readAsBytes();

//         final isVerified = await faceVerificationService.verifyFace(imageBytes);

//         if (!mounted) return;

//         if (isVerified) {
//           showDialog(
//             context: context,
//             builder:
//                 (context) => AlertDialog(
//                   title: const Text('Punch Out Successful'),
//                   content: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.memory(
//                         imageBytes,
//                         height: 150,
//                         width: 150,
//                         fit: BoxFit.cover,
//                       ),
//                       const SizedBox(height: 16),
//                       const Text('Name: Ramesh Kumar'),
//                       const Text('Address: Nashik, Maharashtra'),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Time: ${DateTime.now().toLocal().toString().substring(0, 16)}',
//                       ),
//                     ],
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed:
//                           () => Navigator.of(
//                             context,
//                           ).popUntil((route) => route.isFirst),
//                       child: const Text('OK'),
//                     ),
//                   ],
//                 ),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Face verification failed. Please try again.'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       } catch (e) {
//         debugPrint('Error in captureAndVerify: $e');
//       } finally {
//         if (mounted) {
//           isProcessing.value = false;
//         }
//       }
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Face Verification'),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context, false),
//         ),
//       ),
//       body: Stack(
//         children: [
//           if (cameraController.value != null)
//             CameraPreview(cameraController.value!),
//           if (isProcessing.value)
//             Container(
//               color: Colors.black54,
//               child: const Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       'Verifying face...',
//                       style: TextStyle(color: Colors.white, fontSize: 18),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           Positioned(
//             bottom: 32,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Text(
//                 'Position your face in the frame',
//                 style: GoogleFonts.poppins(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   shadows: [
//                     const Shadow(
//                       offset: Offset(1, 1),
//                       blurRadius: 3.0,
//                       color: Colors.black,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           // Camera switch and gallery pick buttons
//           Positioned(
//             top: 16,
//             left: 16,
//             child: Column(
//               children: [
//                 if (cameras.value.length > 1)
//                   FloatingActionButton(
//                     onPressed: switchCamera,
//                     child: const Icon(Icons.switch_camera),
//                   ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 80,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Column(
//                 children: [
//                   FloatingActionButton(
//                     onPressed: () => captureAndVerify(context.mounted),
//                     child: const Icon(Icons.camera_alt),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     onPressed: () => processStorageImage(context.mounted),
//                     icon: const Icon(Icons.image),
//                     label: const Text('Pick from Gallery'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
