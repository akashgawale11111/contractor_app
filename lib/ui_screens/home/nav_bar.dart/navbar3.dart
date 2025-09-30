import 'package:contractor_app/logic/Apis/provider.dart';
import 'package:contractor_app/ui_screens/home/home_screen.dart';
import 'package:contractor_app/ui_screens/home/profile_screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Navbar3 extends ConsumerWidget {
  const Navbar3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labour = ref.watch(labourProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    int selectedIndex = 0;

    return Container(
      height: height * 0.1, // 10% of screen height
      margin: EdgeInsets.all(width * 0.02), // 2% of screen width
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.03), // 3% of screen width
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: width * 0.005, // 0.5% of screen width
            blurRadius: width * 0.012, // 1.2% of screen width
            offset: Offset(0, height * 0.004), // 0.4% of screen height
          ),
        ],
        color: Colors.white,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.all(width * 0.02), // 2% of screen width
            child: Center(
              child: Container(
                height: height * 0.088, // 8.8% of screen height
                decoration: BoxDecoration(
                  color: const Color(0xFFE85426),
                  borderRadius:
                      BorderRadius.circular(width * 0.03), // 3% of screen width
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        selectedIndex = 0;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home,
                            color: Colors.white,
                            size: width * 0.06, // 6% of screen width
                          ),
                          SizedBox(
                              height: height * 0.006), // 0.6% of screen height
                          Text(
                            'Home',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.025, // 2.5% of screen width
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (labour != null) {
                          selectedIndex = 1;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(labour: labour),
                            ),
                          );
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_2_outlined,
                            color: Colors.white,
                            size: width * 0.06, // 6% of screen width
                          ),
                          SizedBox(
                              height: height * 0.006), // 0.6% of screen height
                          Text(
                            'Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.025, // 2.5% of screen width
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -height * 0.006, // -0.6% of screen height
            left: selectedIndex == 0
                ? width * 0.21
                : width * 0.21, // 23% of screen width for both (centered)
            child: Image.asset(
              'assets/icon/Nav_Icon_Selector.png',
              height: height * 0.038, // 3.8% of screen height
              width: width * 0.075, // 7.5% of screen width
            ),
          ),
        ],
      ),
    );
  }
}
