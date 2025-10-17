import 'package:contractor_app/ui_screens/apps_screen/home/home_screen.dart';
import 'package:contractor_app/ui_screens/apps_screen/menu_bar/custom_drawer.dart';
import 'package:contractor_app/ui_screens/apps_screen/profile_screens/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavExample extends ConsumerStatefulWidget {
  const BottomNavExample({super.key});

  @override
  ConsumerState<BottomNavExample> createState() => _BottomNavExampleState();
}

class _BottomNavExampleState extends ConsumerState<BottomNavExample> {
  int _selectedIndex = 0;

  final List<String> _titles = ["Home", "Profile"];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeScreen(),
      const UserProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ],
        automaticallyImplyLeading: false,
        centerTitle: true, // ✅ Center the title
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.menu,
              size: 28,
              color: Colors.black, // optional
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),

        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
            fontFamily: 'Source Sans 3',
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      drawer: const CustomDrawer(),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: pages[_selectedIndex],

      // -------------------- Bottom Navigation --------------------
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 0, 0),
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
          color: const Color(0xFFE85426),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.white70,
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
