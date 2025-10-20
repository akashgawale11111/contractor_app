// lib/logic/apis/auth_service.dart
import 'dart:convert';
import 'package:contractor_app/logic/models/project_model.dart';
import 'package:contractor_app/logic/models/punchStat.dart';
import 'package:contractor_app/logic/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "http://admin.mmprecise.com/api";
  static const storage = FlutterSecureStorage();

  /// Login API
  static Future<UserModel> login(String labourId, String password) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/login'));
    request.fields['labour_id'] = labourId;
    request.fields['password'] = password;

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = json.decode(responseBody);
      // Save token if API gives one (example: data['token'])
      if (data['token'] != null) {
        await storage.write(key: 'authToken', value: data['token']);
      }
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to login');
    }
  }

  /// Fetch stored token
  static Future<String?> getToken() async {
    return await storage.read(key: 'authToken');
  }

  /// Logout
  static Future<void> logout() async {
    await storage.deleteAll();
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
    print("➡️ Punch-In Body: ${request.fields}");
    print("⬅️ Punch-In Response: $body");

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
    print("➡️ Punch-Out Body: ${request.fields}");
    print("⬅️ Punch-Out Response: $body");

    if (response.statusCode == 200) {
      return PunchModel.fromJson(jsonDecode(body));
    } else {
      throw Exception("Punch Out Failed");
    }
  }
}
