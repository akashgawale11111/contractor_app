import 'package:contractor_app/ui_screens/apps_screen/home/home_screen.dart';
import 'package:contractor_app/ui_screens/apps_screen/menu_bar/custom_drawer.dart';
import 'package:contractor_app/ui_screens/apps_screen/profile_screens/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class BottomNavExample extends ConsumerStatefulWidget {
  const   BottomNavExample({super.key});

  @override
  ConsumerState<BottomNavExample> createState() => _BottomNavExampleState();
}

class _BottomNavExampleState extends ConsumerState<BottomNavExample> {
  int _selectedIndex = 0;
  bool isTab = false;

  @override
  Widget build(BuildContext context) {
   

    final List<Widget> pages = [
      Center(child: HomeScreen()),
      Center(child: UserProfileScreen()),
    ];

    return Scaffold(
     appBar: AppBar(
        title: const Text(
          "Contractor App",
          style: TextStyle(fontFamily: 'Source Sans 3'),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
       
       
      ),
      drawer: CustomDrawer(),
      backgroundColor: Colors.grey.shade300,
      body: pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, "Home", 0),
                _buildNavItem(Icons.person, "Profile", 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.deepOrange,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (isSelected)
                    Positioned(
                      top: -10,
                      child: CustomPaint(
                        size: const Size(20, 10),
                        // painter: TrianglePainter(),
                      ),
                    ),
                  Icon(
                    icon,
                    color: isSelected ? Colors.white : Colors.white70,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
