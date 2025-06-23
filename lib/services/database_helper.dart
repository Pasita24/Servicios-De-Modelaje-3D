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

  Future<void> updateSurveyCompletion({
    required String email,
    required bool completed,
  }) async {
    final db = await database;
    await db.update(
      'users',
      {'has_completed_survey': completed ? 1 : 0},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(
      path,
      version: 6, // Incrementar versión por nuevos campos
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // 1. Primero crea TODAS las tablas
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL,
      name TEXT,
      avatarPath TEXT,
      memberSince TEXT,
      has_completed_survey INTEGER DEFAULT 0
    )
  ''');

    await db.execute('''
    CREATE TABLE plans (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      category TEXT,
      title TEXT,
      imagePath TEXT,
      description TEXT,
      weapon TEXT,
      role TEXT
    )
  ''');
    // 2. Luego inserta los datos iniciales
    await _insertInitialPlans(db); // Método separado para claridad
  }

  Future _insertInitialPlans(Database db) async {
    // Insertar personajes predefinidos
    await db.insert('plans', {
      'category': 'Medieval',
      'title': 'Caballero Valiente',
      'imagePath': 'assets/images/Medieval.png',
      'description':
          'Un guerrero con armadura pesada, ideal para combates cuerpo a cuerpo.',
      'weapon': 'Espada Larga',
      'role': 'Guerrero',
    });
    await db.insert('plans', {
      'category': 'Shooter',
      'title': 'Francotirador Élite',
      'imagePath': 'assets/images/Shooter.png',
      'description': 'Un experto en combate a distancia con precisión letal.',
      'weapon': 'Rifle de Francotirador',
      'role': 'Tirador',
    });
    await db.insert('plans', {
      'category': 'Aventura',
      'title': 'Explorador Místico',
      'imagePath': 'assets/images/Adventura.png',
      'description':
          'Un aventurero que combina magia y habilidades de exploración.',
      'weapon': 'Báculo Encantado',
      'role': 'Mago',
    });
  }

  Future<bool> isEmailRegistered(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  Future<int> createUser(User user) async {
    final db = await database;
    return await db.insert('users', {
      'email': user.email,
      'password': _hashPassword(user.password),
      'name': user.name,
      'avatarPath': user.avatarPath,
      'memberSince': user.memberSince?.toIso8601String(),
    });
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 5) {
      try {
        // Migración para usuarios
        await db.execute(
          'ALTER TABLE users ADD COLUMN has_completed_survey INTEGER DEFAULT 0',
        );

        // ¡Añade la creación de la tabla plans si no existe!
        await db.execute('''
        CREATE TABLE IF NOT EXISTS plans (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          category TEXT,
          title TEXT,
          imagePath TEXT,
          description TEXT,
          weapon TEXT,
          role TEXT
        )
      ''');

        // Opcional: Insertar datos iniciales si es la primera vez
        if (oldVersion < 4) {
          await _insertInitialPlans(db);
        }
      } catch (e) {
        print('Error en migración: $e');
      }
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

  // database_helper.dart
  Future<User?> loginUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, _hashPassword(password)],
    );

    if (result.isNotEmpty) {
      return User(
        id: result.first['id'] as int?,
        email: result.first['email'] as String,
        password: '', // No devolvemos la contraseña real
        name: result.first['name'] as String?,
        avatarPath: result.first['avatarPath'] as String?,
        memberSince:
            result.first['memberSince'] != null
                ? DateTime.parse(result.first['memberSince'] as String)
                : null,
      );
    }
    return null;
  }

  Future<int> updateUserProfile({
    required String email,
    String? name,
    String? avatarPath,
  }) async {
    final db = await database;

    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (avatarPath != null) updates['avatarPath'] = avatarPath;

    return await db.update(
      'users',
      updates,
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
