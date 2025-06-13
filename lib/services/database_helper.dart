import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:servicios_de_modelaje3d/models/plan_data.dart';
import 'package:servicios_de_modelaje3d/models/user.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('plans.db');
    await _fixInvalidImagePaths();
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(
      path,
      version: 2, // Incrementar versión
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
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
    await db.execute('''
         CREATE TABLE users (
           id INTEGER PRIMARY KEY AUTOINCREMENT,
           email TEXT UNIQUE,
           password TEXT
         )
       ''');
    // Insertar usuario de prueba
    await db.insert('users', {
      'email': 'test@modelaje3d.com',
      'password': _hashPassword('password123'),
    });
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
           CREATE TABLE users (
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             email TEXT UNIQUE,
             password TEXT
           )
         ''');
      // Insertar usuario de prueba
      await db.insert('users', {
        'email': 'test@modelaje3d.com',
        'password': _hashPassword('password123'),
      });
    }
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<void> _fixInvalidImagePaths() async {
    final db = await database;
    await db.update(
      'plans',
      {'imagePath': 'assets/images/Medieval.png'},
      where: 'imagePath = ?',
      whereArgs: ['assets/images/default.png'],
    );
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

  Future<int> createUser(User user) async {
    final db = await database;
    return await db.insert('users', {
      'email': user.email,
      'password': _hashPassword(user.password),
    });
  }

  Future<User?> loginUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, _hashPassword(password)],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
