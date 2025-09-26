import 'dart:io';

import 'package:contractor_app/language/lib/l10n/app_localizations.dart';
import 'package:contractor_app/language/lib/l10n/language_provider.dart';
import 'package:contractor_app/ui_screens/authentication/login/loginscreen.dart';
import 'package:contractor_app/ui_screens/home/map_screen/map_screen.dart';
import 'package:contractor_app/ui_screens/menu_bar/attendance_calendar.dart';
import 'package:contractor_app/ui_screens/menu_bar/attendance_history.dart';
import 'package:contractor_app/ui_screens/home/nav_bar.dart/navbar2.dart';
import 'package:contractor_app/ui_screens/menu_bar/payment_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Logout popup function (localized)
void showLogoutPopup(BuildContext context) {
  final loc = AppLocalizations.of(context);
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE990),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.logout, size: 40, color: Colors.black),
              ),
              const SizedBox(height: 20),
              Text(
                loc.logoutConfirm,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Source Sans 3',
                  fontSize: width * 0.036, // font size thoda chhota
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD9D9D9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.06, // kam kiya
                        vertical: height * 0.014,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      loc.cancel,
                      style: TextStyle(
                        fontFamily: 'Source Sans 3',
                        fontSize: width * 0.035,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE85426),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.06, // kam kiya
                        vertical: height * 0.014,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      loc.logout,
                      style: TextStyle(
                        fontFamily: 'Source Sans 3',
                        fontSize: width * 0.035,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class HomeScreen extends ConsumerStatefulWidget {
  final String selectedLanguageCode;
  final Function(String) onLanguageChanged;

  const HomeScreen({
    super.key,
    this.selectedLanguageCode = 'en',
    this.onLanguageChanged = _noop,
  });

  static void _noop(String _) {}

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isPunchedIn = false;
  bool _isPunchedOut = false;
  //int _currentIndex = 0;

  final Map<String, String> languageMap = const {
    'English': 'en',
    'Marathi': 'mr',
    'Hindi': 'hi',
  };

  final List<String> languages = const ['English', 'Marathi', 'Hindi'];

  String getLanguageFromCode(String code) {
    for (var entry in languageMap.entries) {
      if (entry.value == code) {
        return entry.key;
      }
    }
    return 'English'; // Default fallback
  }


  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final currentLocaleCode = ref.watch(localeProvider).languageCode;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.home,
          style: const TextStyle(fontFamily: 'Source Sans 3'),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder:
              (BuildContext context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
      ),
       bottomNavigationBar: Navbar2(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFE85426)),
              child: Text(
                loc.menu,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.055,
                  fontFamily: 'Source Sans 3',
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                '${loc.attendanceCalendar} >',
                style: const TextStyle(fontFamily: 'Source Sans 3'),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AttendenceCal(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: Text(
                '${loc.paymentHistory} >',
                style: const TextStyle(fontFamily: 'Source Sans 3'),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentHistory(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_calendar),
              title: Text(
                '${loc.attendanceHistory}   >',
                style: const TextStyle(fontFamily: 'Source Sans 3'),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Attendence_History(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(
                loc.selectLanguage,
                style: const TextStyle(fontFamily: 'Source Sans 3'),
              ),
              trailing: DropdownButton<String>(
                value: getLanguageFromCode(currentLocaleCode),
                items:
                    languages
                        .map(
                          (lang) => DropdownMenuItem<String>(
                            value: lang,
                            child: Text(lang),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    final languageCode = languageMap[value] ?? 'en';
                    ref
                        .read(localeProvider.notifier)
                        .setLocale(Locale(languageCode));
                  }
                },
              ),
            ),
            SizedBox(height: height * 0.4),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(
                '${loc.settings}   >',
                style: const TextStyle(fontFamily: 'Source Sans 3'),
              ),
              onTap: () {
                showLogoutPopup(context);
              },
            ),
            SizedBox(height: height * 0.006),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(
                '${loc.logout}   >',
                style: const TextStyle(fontFamily: 'Source Sans 3'),
              ),
              onTap: () {
                showLogoutPopup(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: height * 0.025,
            left: width * 0.032,
            right: width * 0.032,
          ),
          child: Column(
            children: List.generate(10, (index) {
              return Container(
                margin: EdgeInsets.only(bottom: height * 0.02),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.028),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/Elevation1.png',
                          width: width * 0.25,
                          height: height * 0.16,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: width * 0.035),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.projectTitle,
                                style: TextStyle(
                                  fontSize: width * 0.037,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFE85426),
                                  fontFamily: 'Source Sans 3',
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              Text(
                                loc.projectAddress,
                                style: TextStyle(
                                  fontSize: width * 0.029,
                                  color: Colors.black54,
                                  fontFamily: 'Source Sans 3',
                                ),
                              ),
                              SizedBox(height: height * 0.012),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed:
                                        _isPunchedIn
                                            ? null
                                            : () {
                                              setState(() {
                                                _isPunchedIn = true;
                                                _isPunchedOut = false;
                                              });
        
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          const PermissionScreen(),
                                                ),
                                              );
                                            },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          _isPunchedIn
                                              ? Colors.grey
                                              : const Color(0xFFE85426),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.05,
                                        vertical: height * 0.012,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      loc.punchIn,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Source Sans 3',
                                        fontSize: width * 0.032,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed:
                                        _isPunchedIn && !_isPunchedOut
                                            ? () {
                                              setState(() {
                                                _isPunchedOut = true;
                                                _isPunchedIn = false;
                                              });
                                            }
                                            : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          _isPunchedOut
                                              ? Colors.grey
                                              : const Color(0xFFE85426),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.05,
                                        vertical: height * 0.012,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      loc.punchOut,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Source Sans 3',
                                        fontSize: width * 0.032,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
