import 'package:intl/intl.dart';
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
  PunchStateNotifier() : super({'isPunchedIn': false, 'projectId': null, 'punchTime': null}) {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final isPunchedIn = prefs.getBool('isPunchedIn') ?? false;
    final projectId = prefs.getInt('projectId');
    final punchTime = prefs.getString('punchTime');
    state = {'isPunchedIn': isPunchedIn, 'projectId': projectId, 'punchTime': punchTime};
  }

  Future<void> punchIn(int projectId) async {
    final prefs = await SharedPreferences.getInstance();
    final punchTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    await prefs.setBool('isPunchedIn', true);
    await prefs.setInt('projectId', projectId);
    await prefs.setString('punchTime', punchTime);
    state = {'isPunchedIn': true, 'projectId': projectId, 'punchTime': punchTime};
  }

  Future<void> punchOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPunchedIn', false);
    await prefs.remove('projectId');
    await prefs.remove('punchTime');
    state = {'isPunchedIn': false, 'projectId': null, 'punchTime': null};
  }
}
