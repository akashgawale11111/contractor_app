import 'package:contractor_app/ui_screens/authentication/login/loginscreen.dart';
import 'package:contractor_app/ui_screens/apps_screen/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✅ Correct import
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contractor_app/logic/Apis/provider.dart';


class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool isLoading = false;
  String statusMessage = 'Initializing...';

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    setState(() {
      isLoading = true;
      statusMessage = 'Checking login status...';
    });

    await Future.delayed(const Duration(seconds: 2));

    final bool isLoggedIn =
        await ref.read(authProvider.notifier).tryAutoLogin();

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomNavExample()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(statusMessage,
                      style: GoogleFonts.poppins(fontSize: 16)),
                ],
              )
            : const SizedBox(),
      ),
    );
  }
}
