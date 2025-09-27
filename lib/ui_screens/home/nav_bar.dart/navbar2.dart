import 'package:contractor_app/logic/Apis/provider.dart';
import 'package:contractor_app/ui_screens/home/home_screen.dart';
import 'package:contractor_app/ui_screens/home/profile_screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Navbar2 extends ConsumerWidget {
  const Navbar2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labour = ref.watch(labourProvider);
    int selectedIndex = 0;
    return Container(
      height: 80,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        color: Colors.white,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFFE85426),
                  borderRadius: BorderRadius.circular(12.0),
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
                        children: const [
                          Icon(Icons.home, color: Colors.white),
                          SizedBox(height: 5),
                          Text(
                            'Home',
                            style: TextStyle(color: Colors.white, fontSize: 10),
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
                              builder: (context) => ProfileScreen(labour: labour),
                            ),
                          );
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.person_2_outlined, color: Colors.white),
                          SizedBox(height: 5),
                          Text(
                            'Profile',
                            style: TextStyle(color: Colors.white, fontSize: 10),
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
            top: -5,
            left: selectedIndex == 0 ? 293 : 293,
            child: Image.asset(
              'assets/icon/Nav_Icon_Selector.png',
              height: 30,
              width: 30,
            ),
          ),
        ],
      ),
    );
  }
}