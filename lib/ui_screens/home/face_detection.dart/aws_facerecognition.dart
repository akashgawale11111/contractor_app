import 'dart:io';
import 'package:aws_client/rekognition_2016_06_27.dart' as aws;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class FaceCompareAWS extends StatefulWidget {
  const FaceCompareAWS({super.key});

  @override
  State<FaceCompareAWS> createState() => _FaceCompareAWSState();
}

class _FaceCompareAWSState extends State<FaceCompareAWS> {
  File? _image1, _image2;
  final picker = ImagePicker();
  String _result = "";
  bool _isComparing = false;

  late final aws.Rekognition rekognition;

  @override
  void initState() {
    super.initState();
    rekognition = aws.Rekognition(
      region: "ap-south-1",
      credentials: aws.AwsClientCredentials(
        accessKey: "AKIAQTXFPFMNBGZN7NVV",
        secretKey: "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",
      ),
    );
  }

  Future<void> _pickImage(int index, ImageSource source) async {
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        if (index == 1) {
          _image1 = File(picked.path);
        } else {
          _image2 = File(picked.path);
        }
      });
    }
  }

  Future<void> _compareFaces() async {
    if (_image1 == null || _image2 == null) {
      setState(() => _result = "⚠️ Please select both images!");
      return;
    }

    setState(() {
      _isComparing = true;
      _result = "🔍 Comparing...";
    });

    try {
      final bytes1 = await _image1!.readAsBytes();
      final bytes2 = await _image2!.readAsBytes();

      final response = await rekognition.compareFaces(
        sourceImage: aws.Image(bytes: bytes1),
        targetImage: aws.Image(bytes: bytes2),
        similarityThreshold: 80,
      );

      if (response.faceMatches != null && response.faceMatches!.isNotEmpty) {
        final match = response.faceMatches!.first.similarity;
        setState(() => _result =
            "✅ Face Matched! (Similarity: ${match?.toStringAsFixed(2)}%)");
      } else {
        setState(() => _result = "❌ Faces do not match.");
      }
    } catch (e) {
      setState(() => _result = "❌ Error: ${e.toString()}");
    } finally {
      setState(() => _isComparing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AWS Face Recognition")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _image1 != null ? FileImage(_image1!) : null,
                child: _image1 == null ? const Text("Image 1") : null,
              ),
              CircleAvatar(
                radius: 50,
                backgroundImage: _image2 != null ? FileImage(_image2!) : null,
                child: _image2 == null ? const Text("Image 2") : null,
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isComparing ? null : _compareFaces,
            child: _isComparing
                ? const CircularProgressIndicator()
                : const Text("Compare Faces"),
          ),
          const SizedBox(height: 20),
          Text(
            _result,
            textAlign: TextAlign.center,
            style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text("Selfie 1"),
                onPressed: () => _pickImage(1, ImageSource.camera),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.photo),
                label: const Text("Gallery 1"),
                onPressed: () => _pickImage(1, ImageSource.gallery),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text("Selfie 2"),
                onPressed: () => _pickImage(2, ImageSource.camera),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.photo),
                label: const Text("Gallery 2"),
                onPressed: () => _pickImage(2, ImageSource.gallery),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


