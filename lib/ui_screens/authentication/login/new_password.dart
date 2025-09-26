import 'package:contractor_app/custom_Widgets/custom_button.dart';
import 'package:contractor_app/custom_Widgets/custom_password_field.dart';
import 'package:contractor_app/ui_screens/authentication/login/loginscreen.dart';

import 'package:flutter/material.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
                  'Log In for exclusive designs, deals & quick checkout.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),

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
                  text: 'Set Password',
                  onPressed: () {
                    // Handle sign-up
                     Navigator.push(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
