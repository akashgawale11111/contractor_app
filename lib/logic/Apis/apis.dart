// lib/logic/apis/auth_service.dart
import 'dart:convert';
import 'package:contractor_app/logic/models/project_model.dart';
import 'package:contractor_app/logic/models/punch_stat.dart';
import 'package:contractor_app/logic/models/user_model.dart';
import 'package:contractor_app/utils/shared_prefs.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "http://admin.mmprecise.com/api";
  static const storage = FlutterSecureStorage();

  /// Fetch attendance history
  static Future<Map<String, dynamic>> getAttendanceHistory({
    required String userType,
    required String userId,
  }) async {
    print("====================================================");
    print("🔹 Starting ATTENDANCE HISTORY request...");
    print("🔹 Endpoint: $baseUrl/attendance-history");
    print("🔹 User Type: $userType");
    print("🔹 User ID: $userId");

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/attendance-history?user_type=$userType&user_id=$userId'),
      );

      print("✅ Response status: ${response.statusCode}");
      print("📦 Raw response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("✅ Successfully parsed response");
        print("====================================================");
        return data;
      } else {
        print("❌ Request failed with status: ${response.statusCode}");
        print("❌ Error response: ${response.body}");
        print("====================================================");
        throw Exception('Failed to load attendance history: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Exception occurred: $e");
      print("====================================================");
      throw Exception('Error fetching attendance history: $e');
    }
  }

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
      
      // Save user info to SharedPreferences
      final userType = user.isLabour ? 'labour' : (user.isSupervisor ? 'supervisor' : '');
      await SharedPrefs.saveUserInfo(userId, userType);
      
      print("✅ Parsed UserData successfully");
      print("👷 Is Labour: ${user.isLabour}");
      print("🧑‍💼 Is Supervisor: ${user.isSupervisor}");
      print("💾 Saved user info - Type: $userType, ID: $userId");
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
    int? labourId,
    int? supervisorId,
    String? supervisorLoginId,
    required int projectId,
    required String punchInTime,
    required bool isSupervisor,
  }) async {
    // Build JSON payload per backend examples (curl)
    final payload = <String, dynamic>{
      'status': 'punchin',
      'project_id': projectId,
      'punch_in_time': punchInTime,
    };

    if (isSupervisor) {
      payload['user_type'] = 'supervisor';
      // prefer login id if available (backend example uses login_id for supervisor)
      if (supervisorLoginId != null && supervisorLoginId.isNotEmpty) {
        payload['login_id'] = supervisorLoginId;
      } else if (supervisorId != null) {
        // fallback: send numeric supervisor id with key supervisor_id (some endpoints accept either)
        payload['supervisor_id'] = supervisorId;
      }
    } else {
      payload['user_type'] = 'labour';
      if (labourId != null) payload['labour_id'] = labourId;
    }

    // Use HTTPS (matching cURL examples)
    final url = Uri.parse(baseUrl.replaceFirst('http://', 'https://') + '/attendance');

    print('====================================================');
    print('🔹 AuthService.punchIn sending JSON POST');
    print('  URL: $url');
    print('  Payload: $payload');
    if ((payload['punch_in_time'] ?? '').toString().trim().isEmpty) {
      print('⚠️ WARNING: punch_in_time is empty or missing in payload');
    }

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    print('🔸 punchIn response status: ${response.statusCode}');
    print('🔸 punchIn response body: ${response.body}');
    print('====================================================');

    if (response.statusCode == 200) {
      return PunchModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Punch In Failed: 404 Not Found. URL: $url - Response body: ${response.body}');
    } else {
      throw Exception('Punch In Failed: ${response.statusCode} - ${response.body}');
    }
  }

  /// 🔹 PUNCH OUT
  static Future<PunchModel> punchOut({
    required int attendanceId,
    required String punchOutTime,
    int? labourId,
    int? supervisorId,
    required int projectId,
    required bool isSupervisor,
  }) async {
    // Backend expects JSON body like: { "attendance_id": 50, "status": "punchout" }
    final payload = <String, dynamic>{
      'attendance_id': attendanceId,
      'status': 'punchout',
    };

    final url = Uri.parse(baseUrl.replaceFirst('http://', 'https://') + '/attendance');
    print('====================================================');
    print('🔹 AuthService.punchOut sending JSON POST');
    print('  URL: $url');
    print('  Payload: $payload');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    print('🔸 punchOut response status: ${response.statusCode}');
    print('🔸 punchOut response body: ${response.body}');
    print('====================================================');

    if (response.statusCode == 200) {
      return PunchModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Punch Out Failed: 404 Not Found. URL: $url - Response body: ${response.body}');
    } else {
      throw Exception('Punch Out Failed: ${response.statusCode} - ${response.body}');
    }
  }
}
