// import 'package:flutter/material.dart';

// class Navbar extends StatefulWidget {
//   const Navbar({super.key});

//   @override
//   State<Navbar> createState() => _NavbarState();
// }

// class _NavbarState extends State<Navbar> {
//   int selectedIndex = 0;

//   // तुझ्या navigation ची screens list
//   final List<Widget> _screens = [
//     HomeScreen(selectedLanguageCode: 'en', onLanguageChanged: (code) {}),
//    // ProfileScreen(labour: Labour(id: 0, name: '', email: '', phone: '', address: '', uid: '', profileImage: '')),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(index: selectedIndex, children: _screens),
//       bottomNavigationBar: Container(
//         height: 80,
//         margin: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12.0),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//           color: Colors.white,
//         ),
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Center(
//                 child: Container(
//                   height: 70,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFE85426),
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       GestureDetector(
//                         onTap: () => setState(() => selectedIndex = 0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Icon(Icons.home, color: Colors.white),
//                             SizedBox(height: 5),
//                             Text(
//                               'Home',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 10,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () => setState(() => selectedIndex = 1),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Icon(Icons.person_2_outlined, color: Colors.white),
//                             SizedBox(height: 5),
//                             Text(
//                               'Profile',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 10,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: -5,
//               left: selectedIndex == 0 ? 93 : 293,
//               child: Image.asset(
//                 'assets/icon/Nav_Icon_Selector.png',
//                 height: 30,
//                 width: 30,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// class StackDashboard extends StatefulWidget {
//   @override
//   _StackDashboardState createState() => _StackDashboardState();
// }

// class _StackDashboardState extends State<StackDashboard> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     Center(child: Text("Home Screen", style: TextStyle(fontSize: 24))),
//     Center(child: Text("Profile Screen", style: TextStyle(fontSize: 24))),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   Widget _buildNavItem(IconData icon, String label, int index) {
//   bool isSelected = _selectedIndex == index;
//   return Expanded(
//     child: InkWell(
//       onTap: () => _onItemTapped(index),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Arrow (फक्त selected असताना दिसेल, नाहीतर काहीच नाही)
//           if (isSelected)
//             Image.asset(
//               "assets/icon/Nav_Icon_Selector.png",
//               height: 18, // इथे height कमी ठेव
//               width: 18,
//             ),

//           Icon(icon, color: Colors.white),
//           Text(
//             label,
//             style: TextStyle(color: Colors.white, fontSize: 12),
//           ),
//         ],
//       ),
//     ),
//   );
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           _pages[_selectedIndex],

//           // Custom Bottom Navigation
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               margin: EdgeInsets.all(12),
//               padding: EdgeInsets.symmetric(vertical: 0),
//               decoration: BoxDecoration(
//                 color: Colors.deepOrange,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(
//                 children: [
//                   _buildNavItem(Icons.home, "Home", 0),
//                   _buildNavItem(Icons.person, "Profile", 1),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
