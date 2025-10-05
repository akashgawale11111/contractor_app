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

  static Future<punchStatus> punchIn({
    required int labourId,
    required int projectId,
    required String punchInTime,
  }) async {
    final url = Uri.parse('$baseUrl/attendance');
    final body = {
      'labour_id': labourId.toString(),
      'project_id': projectId.toString(),
      'punch_in_time': punchInTime,
    };

    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      return punchStatus.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to punch in: ${response.body}');
    }
  }

  static Future<punchStatus> punchOut({
    required int labourId,
    required int projectId,
    required String punchOutTime,
  }) async {
    final url = Uri.parse('$baseUrl/attendance');
    final body = {
      'labour_id': labourId.toString(),
      'project_id': projectId.toString(),
      'punch_out_time': punchOutTime,
    };

    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      return punchStatus.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to punch out: ${response.body}');
    }
  }

  
}
