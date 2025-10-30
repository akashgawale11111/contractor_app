import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static Future<Map<String, String>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? '';
    final userType = prefs.getString('user_type') ?? '';
    return {
      'userId': userId,
      'userType': userType,
    };
  }

  static Future<void> saveUserInfo(String userId, String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
    await prefs.setString('user_type', userType);
  }
}