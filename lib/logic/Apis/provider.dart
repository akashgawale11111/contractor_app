import 'dart:convert';
import 'package:contractor_app/logic/Apis/apis.dart';
import 'package:contractor_app/logic/models/project_model.dart';
import 'package:contractor_app/logic/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final projectProvider = FutureProvider<ProjectModel>((ref) async {
  return await AuthService.fetchProjects();
});
final projectProviderList = FutureProvider<ProjectModel>((ref) async {
  return await AuthService.fetchProjects();
});
final projectProviderID = FutureProvider<ProjectModel>((ref) async {
  return await AuthService.fetchProjects();
});

final authProvider = StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<UserModel?> {
  AuthNotifier() : super(null);

  Future<void> login(String labourId, String password) async {
    try {
      final user = await AuthService.login(labourId, password);
      state = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      // For security, sensitive user data should be stored in flutter_secure_storage.
      // For this example, we are using SharedPreferences for simplicity.
      await prefs.setString('user', json.encode(user.toJson()));
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('isLoggedIn') || prefs.getBool('isLoggedIn') == false) {
      return false;
    }

    if (!prefs.containsKey('user')) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('user')!) as Map<String, dynamic>;
    final user = UserModel.fromJson(extractedUserData);
    state = user;
    return true;
  }

  Future<void> logout() async {
    await AuthService.logout();
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('user');
  }
}
