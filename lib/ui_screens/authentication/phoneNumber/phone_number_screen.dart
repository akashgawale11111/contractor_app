import 'package:contractor_app/custom_Widgets/custom_button.dart';
import 'package:contractor_app/custom_Widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Image.asset(
                  'assets/images/mmprecise.png',
                  height: 100,
                ), // Replace with your logo
                SizedBox(height: 20),
                Text(
                  'We’ll send a reset OTP to your registered phone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),

                CustomTextField(
                  controller: phoneController,
                  hintText: 'Adhar Number',
                  keyboardType: TextInputType.phone,
                ),

                SizedBox(height: 20),
                CustomButton(
                  text: 'Send OTP',
                  onPressed: () {
                   // Navigator.push(context, MaterialPageRoute(builder: (_)=> OtpScreen()));
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
