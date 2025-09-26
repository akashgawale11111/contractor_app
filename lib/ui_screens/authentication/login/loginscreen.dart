import 'dart:convert';

import 'package:contractor_app/custom_Widgets/custom_button.dart';
import 'package:contractor_app/custom_Widgets/custom_password_field.dart';
import 'package:contractor_app/custom_Widgets/custom_text_field.dart';
import 'package:contractor_app/models/user_model.dart';
import 'package:contractor_app/riverpod/labour_provider.dart';
import 'package:contractor_app/ui_screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController uidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;

  Future<void> loginUser() async {
    setState(() => loading = true);
    // user login API call

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://admin.mmprecise.com/api/login"),
      );
      request.fields['labour_id'] = uidController.text.trim();
      request.fields['password'] = passwordController.text.trim();

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        UserModel userModel = UserModel.fromJson(data);

        if (userModel.labour != null) {
          ref.read(labourProvider.notifier).state = userModel.labour;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid response: No labour data")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/mmprecise.png',
                  height: 100,
                ), // Replace with your logo
                const SizedBox(height: 20),
                const Text(
                  'Log In for exclusive designs, deals & quick checkout.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: uidController,
                  hintText: 'Phone Number',
                  keyboardType: TextInputType.phone,
                ),
                CustomPasswordField(
                  controller: passwordController,
                  hintText: 'Enter Password',
                ),
                const SizedBox(height: 5),
                const SizedBox(height: 5),
                const SizedBox(height: 20),
                loading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        onPressed: loginUser,
                        text: 'Log In',
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
