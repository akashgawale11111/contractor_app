import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';

final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});

final punchStateProvider = StateNotifierProvider<PunchStateNotifier, Map<String, dynamic>>((ref) {
  return PunchStateNotifier();
});

class PunchStateNotifier extends StateNotifier<Map<String, dynamic>> {
  PunchStateNotifier() : super({'isPunchedIn': false, 'projectId': null}) {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final isPunchedIn = prefs.getBool('isPunchedIn') ?? false;
    final projectId = prefs.getString('projectId');
    state = {'isPunchedIn': isPunchedIn, 'projectId': projectId};
  }

  Future<void> punchIn(String projectId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPunchedIn', true);
    await prefs.setString('projectId', projectId);
    state = {'isPunchedIn': true, 'projectId': projectId};
  }

  Future<void> punchOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPunchedIn', false);
    await prefs.remove('projectId');
    state = {'isPunchedIn': false, 'projectId': null};
  }
}
