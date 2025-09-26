import 'package:contractor_app/custom_Widgets/custom_button.dart';
import 'package:contractor_app/custom_Widgets/custom_date_picker.dart';
import 'package:contractor_app/custom_Widgets/custom_dropdown.dart';
import 'package:contractor_app/custom_Widgets/custom_password_field.dart';
import 'package:contractor_app/custom_Widgets/custom_text_field.dart';
import 'package:contractor_app/ui_screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? selectedGender;
  String? selectedPost;
  DateTime? selectedDate;
  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _showImageSourceDialog() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Image.asset(
                  'assets/images/mmprecise.png',
                  height: 100,
                ), // Replace with your logo
                SizedBox(height: 20),
                Text(
                  'Sign up for exclusive designs, deals & quick checkout.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 24),

                // Profile Image Picker
                GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage:
                            _profileImage != null
                                ? FileImage(_profileImage!)
                                : null,
                        child:
                            _profileImage == null
                                ? Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey[700],
                                )
                                : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.camera_alt, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                CustomTextField(
                  controller: nameController,
                  hintText: 'Enter Full Name',
                ),
                CustomTextField(
                  controller: phoneController,
                  hintText: 'Adhar Number',
                  keyboardType: TextInputType.phone,
                ),

                CustomDropdown(
                  hint: 'Gender',
                  items: ['Male', 'Female', 'Other'],
                  value: selectedGender,
                  onChanged: (value) => setState(() => selectedGender = value),
                ),

                CustomDatePicker(
                  selectedDate: selectedDate,
                  onDateSelected: (date) => setState(() => selectedDate = date),
                ),

                CustomDropdown(
                  hint: 'Posts',
                  items: ['Supervisor', 'Manager', 'Worker'],
                  value: selectedPost,
                  onChanged: (value) => setState(() => selectedPost = value),
                ),

                CustomPasswordField(
                  controller: passwordController,
                  hintText: 'Create Password',
                ),
                CustomPasswordField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                ),

                SizedBox(height: 20),
                CustomButton(
                  text: 'SIGN UP',
                  onPressed: () {
                    // Replace the current screen with HomeScreen so the user can't go back.
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => const HomeScreen(),
                      ),
                    );
                  },
                ),

                SizedBox(height: 10),
                TextButton(
                   onPressed: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (_) => LoginScreen()),
                  //   );
                  },
                  child: Text.rich(
                    TextSpan(
                      text: 'Already have an account?',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 52, 52, 52),
                      ),
                      children: [
                        TextSpan(
                          text: 'Log In',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
