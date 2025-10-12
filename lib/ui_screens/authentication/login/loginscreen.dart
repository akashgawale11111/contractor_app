import 'package:contractor_app/logic/Apis/provider.dart';
import 'package:contractor_app/ui_screens/apps_screen/navbar.dart';
import 'package:contractor_app/utils/custom_Widgets/custom_button.dart';
import 'package:contractor_app/utils/custom_Widgets/custom_password_field.dart';
import 'package:contractor_app/utils/custom_Widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _labourIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
   bool _obscureText = true; // default: hide password

  void _login() async {
    setState(() => _isLoading = true);
    try {
      await ref
          .read(authProvider.notifier)
          .login(_labourIdController.text, _passwordController.text);
      // Navigate to profile screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomNavExample()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
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
                  controller: _labourIdController,
                  hintText: 'Labour ID',
                  keyboardType: TextInputType.text,
                ),
                CustomPasswordField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: _obscureText,
                  onToggle: () {
                    setState(() {_obscureText = !_obscureText;});
                  },
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        onPressed: _login,
                        text: 'Login',
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
