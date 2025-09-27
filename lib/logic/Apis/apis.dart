import 'dart:convert';
import 'package:aws_client/rekognition_2016_06_27.dart';
import 'package:contractor_app/logic/models/project_model.dart';
import 'package:contractor_app/logic/models/user_model.dart';
import 'package:http/http.dart' as http;

class ProjecApiService {
  static const String baseUrl = "https://admin.mmprecise.com/api";

  static Future<ProjectModel> fetchProjects() async {
    final response = await http.get(Uri.parse('$baseUrl/getallprojects'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProjectModel.fromJson(data);
    } else {
      throw Exception("Failed to load projects");
    }
  }

  static Future<UserModel> fetchUserData() async {
    final response = await http.get(Uri.parse('$baseUrl/login'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception("Failed to load User Data");
    }
  }

}
