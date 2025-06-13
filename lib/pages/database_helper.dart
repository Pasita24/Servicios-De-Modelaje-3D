import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:servicios_de_modelaje3d/models/plan_data.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('plans.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE plans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT,
        title TEXT,
        imagePath TEXT,
        description TEXT
      )
    ''');
  }

  Future<int> createPlan(PlanData plan) async {
    final db = await database;
    return await db.insert('plans', plan.toMap());
  }

  Future<List<PlanData>> getPlans() async {
    final db = await database;
    final result = await db.query('plans');
    return result.map((map) => PlanData.fromMap(map)).toList();
  }

  Future<int> updatePlan(PlanData plan) async {
    final db = await database;
    return await db.update(
      'plans',
      plan.toMap(),
      where: 'id = ?',
      whereArgs: [plan.id],
    );
  }

  Future<int> deletePlan(int id) async {
    final db = await database;
    return await db.delete('plans', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
