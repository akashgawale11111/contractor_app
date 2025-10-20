import 'package:contractor_app/logic/Apis/provider.dart';
import 'package:contractor_app/ui_screens/apps_screen/menu_bar/customDrawerScreen/attendance_history.dart';
import 'package:contractor_app/ui_screens/apps_screen/menu_bar/customDrawerScreen/payment_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:contractor_app/language/lib/l10n/app_localizations.dart';
import 'package:contractor_app/language/lib/l10n/language_provider.dart';
import 'package:contractor_app/ui_screens/apps_screen/menu_bar/customDrawerScreen/attendance_calendar.dart';
import 'package:contractor_app/ui_screens/authentication/login/loginscreen.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
    final currentLocaleCode = ref.watch(localeProvider).languageCode;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final Map<String, String> languageMap = {
      'English': 'en',
      'Marathi': 'mr',
      'Hindi': 'hi',
    };

    String getLanguageFromCode(String code) {
      for (var entry in languageMap.entries) {
        if (entry.value == code) {
          return entry.key;
        }
      }
      return 'English';
    }

    final List<String> languages = ['English', 'Marathi', 'Hindi'];

    return Drawer(
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
            title: Text('${loc.attendanceCalendar} >'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AttendenceCal()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: Text('${loc.paymentHistory} >'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaymentHistory()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_calendar),
            title: Text('${loc.attendanceHistory} >'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AttendanceHistory()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(loc.selectLanguage),
            trailing: DropdownButton<String>(
              value: getLanguageFromCode(currentLocaleCode),
              items: languages
                  .map((lang) => DropdownMenuItem<String>(
                        value: lang,
                        child: Text(lang),
                      ))
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
            title: Text('${loc.settings} >'),
            onTap: () {
              showLogoutPopup(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text('${loc.logout} >'),
            onTap: () {
              ref.read(authProvider.notifier).logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

void showLogoutPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Logout"),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      );
    },
  );
}
