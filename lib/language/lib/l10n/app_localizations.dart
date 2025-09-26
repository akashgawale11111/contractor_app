import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Simple Language App',
      'greeting': 'Hello!',
      'home': 'Home',
      'profile': 'Profile',
      'changeLanguage': 'Change Language',
      'paymentHistory': 'Your Payment History',
      'logout': 'Logout',
      'projectTitle': 'Residential Tower – Masonry Work',
      'projectAddress': '12, 6th floor, Asha building, Tidake colony, near Real Durvankar lawns, Nashik, Maharashtra - 422009',
      'punchIn': 'Punch In',
      'punchOut': 'Punch Out',
      'selectLanguage': 'Select Language',
      'cancel': 'Cancel',
      'menu': 'Menu',
      'attendanceCalendar': 'Attendance Calendar',
      'attendanceHistory': 'Attendance History',
      'settings': 'Settings',
      'logoutConfirm': 'Are you sure you want to log out of your account?',
    },
    'hi': {
      'title': 'सरल भाषा ऐप',
      'greeting': 'नमस्ते!',
      'home': 'होम',
      'profile': 'प्रोफ़ाइल',
      'changeLanguage': 'भाषा बदलो',
      'paymentHistory': 'आपका भुगतान इतिहास',
      'logout': 'लॉग आउट',
      'projectTitle': 'आवासीय टॉवर - चिनाई का काम',
      'projectAddress': '12, 6वीं मंजिल, आशा बिल्डिंग, तिड़के कॉलोनी, रियल दुर्वांकर लॉन के पास, नासिक, महाराष्ट्र - 422009',
      'punchIn': 'पंच इन',
      'punchOut': 'पंच आउट',
      'selectLanguage': 'भाषा चुनें',
      'cancel': 'रद्द करें',
      'menu': 'मेनू',
      'attendanceCalendar': 'उपस्थिति कैलेंडर',
      'attendanceHistory': 'उपस्थिति इतिहास',
      'settings': 'सेटिंग्स',
      'logoutConfirm': 'क्या आप वाकई अपने खाते से लॉग आउट करना चाहते हैं?',
    },
    'mr': {
      'title': 'सोपे भाषा अ‍ॅप',
      'greeting': 'नमस्कार!',
      'home': 'मुख्यपृष्ठ',
      'profile': 'प्रोफाइल',
      'changeLanguage': 'भाषा बदला',
      'paymentHistory': 'तुमचा पेमेंट इतिहास',
      'logout': 'लॉग आउट',
      'projectTitle': 'निवासी टॉवर – गवंडी काम',
      'projectAddress': '१२, ६ वा मजला, आशा बिल्डिंग, तिडके कॉलनी, रियल दुर्वांकुर लॉन जवळ, नाशिक, महाराष्ट्र - ४२२००९',
      'punchIn': 'पंच इन',
      'punchOut': 'पंच आउट',
      'selectLanguage': 'भाषा निवडा',
      'cancel': 'रद्द करा',
      'menu': 'मेनू',
      'attendanceCalendar': 'हजेरी दिनदर्शिका',
      'attendanceHistory': 'हजेरी इतिहास',
      'settings': 'सेटिंग्ज',
      'logoutConfirm': 'आपण खात्यातून लॉग आउट करू इच्छिता याची खात्री आहे का?',
    },
  };

  String get title => _localizedValues[locale.languageCode]!['title']!;
  String get greeting => _localizedValues[locale.languageCode]!['greeting']!;
  String get home => _localizedValues[locale.languageCode]!['home']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get changeLanguage => _localizedValues[locale.languageCode]!['changeLanguage']!;
  String get paymentHistory => _localizedValues[locale.languageCode]!['paymentHistory']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get projectTitle => _localizedValues[locale.languageCode]!['projectTitle']!;
  String get projectAddress => _localizedValues[locale.languageCode]!['projectAddress']!;
  String get punchIn => _localizedValues[locale.languageCode]!['punchIn']!;
  String get punchOut => _localizedValues[locale.languageCode]!['punchOut']!;
  String get selectLanguage => _localizedValues[locale.languageCode]!['selectLanguage']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get menu => _localizedValues[locale.languageCode]!['menu']!;
  String get attendanceCalendar => _localizedValues[locale.languageCode]!['attendanceCalendar']!;
  String get attendanceHistory => _localizedValues[locale.languageCode]!['attendanceHistory']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get logoutConfirm => _localizedValues[locale.languageCode]!['logoutConfirm']!;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
