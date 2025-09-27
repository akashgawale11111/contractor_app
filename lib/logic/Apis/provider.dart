import 'package:contractor_app/logic/Apis/apis.dart';
import 'package:contractor_app/logic/models/project_model.dart';
import 'package:contractor_app/logic/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final projectProvider = FutureProvider<ProjectModel>((ref) async {
  return await ProjecApiService.fetchProjects();
});
final userDataProvider = FutureProvider<UserModel>((ref) async {
  return await ProjecApiService.fetchUserData();
});


final labourProvider = StateProvider<Labour?>((ref) => null);