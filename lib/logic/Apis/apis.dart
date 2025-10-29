// lib/logic/apis/auth_service.dart
import 'dart:convert';
import 'package:contractor_app/logic/models/project_model.dart';
import 'package:contractor_app/logic/models/punch_stat.dart';
import 'package:contractor_app/logic/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "http://admin.mmprecise.com/api";
  static const storage = FlutterSecureStorage();

  /// Handles login for both Labour & Supervisor
  static Future<UserData> login(String userId, String password) async {
    print("====================================================");
    print("🔹 Starting LOGIN request...");
    print("🔹 Endpoint: $baseUrl/login");
    print("🔹 Entered user_id/login_id: $userId");

    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/login'));

      // ✅ Send both fields: backend will use the correct one
      request.fields['user_id'] = userId; // for Labour
      request.fields['login_id'] = userId; // for Supervisor
      request.fields['password'] = password;

      print("🕓 Sending request...");
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("✅ Response status: ${response.statusCode}");
      print("📦 Raw response body: $responseBody");

      final data = json.decode(responseBody);

      if (response.statusCode != 200) {
        throw Exception("Failed to login (${response.statusCode})");
      }

      if (data['status'] == false) {
        throw Exception(data['message'] ?? "Invalid credentials");
      }

      // ✅ Store token securely
      if (data['token'] != null) {
        await storage.write(key: 'authToken', value: data['token']);
      }

      final user = UserData.fromJson(data);
      print("✅ Parsed UserData successfully");
      print("👷 Is Labour: ${user.isLabour}");
      print("🧑‍💼 Is Supervisor: ${user.isSupervisor}");
      print("====================================================");

      return user;
    } catch (e, stack) {
      print("❌ Login failed: $e");
      print(stack);
      print("====================================================");
      throw Exception("Login failed: $e");
    }
  }

  /// Logout user and clear stored token
  static Future<void> logout() async {
    print("🚪 Logging out and clearing secure storage...");
    await storage.deleteAll();
    print("✅ Logout complete");
  }

  /// Fetch all projects
  static Future<ProjectModel> fetchProjects() async {
    final response = await http.get(Uri.parse('$baseUrl/getallprojects'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProjectModel.fromJson(data);
    } else {
      throw Exception("Failed to load projects");
    }
  }

  /// 🔹 PUNCH IN
  static Future<PunchModel> punchIn({
    required int labourId,
    required int projectId,
    required String punchInTime,
  }) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/attendance'));
    request.fields['labour_id'] = labourId.toString();
    request.fields['project_id'] = projectId.toString();
    request.fields['status'] = "punchin";
    request.fields['punch_in_time'] = punchInTime; // 🔹 custom field (optional)

    var response = await request.send();
    var body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return PunchModel.fromJson(jsonDecode(body));
    } else {
      throw Exception("Punch In Failed");
    }
  }

  /// 🔹 PUNCH OUT
  static Future<PunchModel> punchOut({
    required int attendanceId,
    required String punchOutTime,
    required int labourId,
    required int projectId,
  }) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/attendance'));
    request.fields['status'] = "punchout";
    request.fields['attendance_id'] = attendanceId.toString();
    request.fields['punch_out_time'] =
        punchOutTime; // 🔹 custom field (optional)
    request.fields['labour_id'] = labourId.toString();
    request.fields['project_id'] = projectId.toString();

    var response = await request.send();
    var body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return PunchModel.fromJson(jsonDecode(body));
    } else {
      throw Exception("Punch Out Failed");
    }
  }
}
