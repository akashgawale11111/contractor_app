import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'contractor_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE punches(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        projectId TEXT,
        punchInTime TEXT,
        punchOutTime TEXT,
        isSynced INTEGER DEFAULT 0
      )
    ''');
  }

  Future<int> insertPunch(Map<String, dynamic> punch) async {
    final db = await database;
    return await db.insert('punches', punch);
  }

  Future<List<Map<String, dynamic>>> getPunches() async {
    final db = await database;
    return await db.query('punches');
  }

  Future<int> updatePunch(Map<String, dynamic> punch) async {
    final db = await database;
    return await db
        .update('punches', punch, where: 'id = ?', whereArgs: [punch['id']]);
  }

  Future<Map<String, dynamic>?> getLastOpenPunchForProject(
      String projectId) async {
    final db = await database;
    final result = await db.query(
      'punches',
      where: 'projectId = ? AND punchOutTime IS NULL',
      whereArgs: [projectId],
      orderBy: 'id DESC',
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}
