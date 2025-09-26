import 'package:contractor_app/logic/Apis/apis.dart';
import 'package:contractor_app/logic/Apis/apis.dart';
import 'package:contractor_app/models/project_Model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final projectProvider = FutureProvider<ProjectModel>((ref) async {
  return await ProjecApiService.fetchProjects();
});
