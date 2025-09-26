import 'package:contractor_app/ui_screens/authentication/login/loginscreen.dart';
import 'package:contractor_app/ui_screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends HookWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final statusMessage = useState('Initializing...');

    // Initialize app and check login status
    Future<void> initializeApp() async {
      isLoading.value = true;
      statusMessage.value = 'Checking login status...';

      final prefs = await SharedPreferences.getInstance();
      await Future.delayed(const Duration(seconds: 2)); // Simulate loading

      final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (!context.mounted) return;

      if (isLoggedIn) {
        // ✅ Go to Home if logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      } else {
        // ❌ Go to Login if not
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }

    // useEffect to run init on widget build
    useEffect(() {
      initializeApp();
      return null;
    }, []);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Image.asset('assets/images/mmprecise.png', height: 100),
              ),
              const SizedBox(height: 32),

              // App name
              Text(
                'Construction\nEmployee Manager',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 48),

              // Loading indicator
              if (isLoading.value) ...[
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  statusMessage.value,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                ),
              ],
              if (!isLoading.value) ...[
                ElevatedButton(
                  onPressed: initializeApp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
