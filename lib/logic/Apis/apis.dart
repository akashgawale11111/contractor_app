import 'dart:convert';
import 'package:contractor_app/models/project_Model.dart';
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
}

