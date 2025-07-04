// auth_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:servicios_de_modelaje3d/models/user.dart';
import 'package:servicios_de_modelaje3d/services/database_helper.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  late SharedPreferences _prefs;

  User? get user => _user;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadUserFromPrefs();
  }

  // Modificar el método _loadUserFromPrefs para cargar correctamente el estado de la encuesta
  Future<void> _loadUserFromPrefs() async {
    final email = _prefs.getString('user_email');
    final name = _prefs.getString('user_name');
    final avatarPath = _prefs.getString('user_avatar');
    final memberSince = _prefs.getString('user_member_since');
    final hasCompletedSurvey = _prefs.getBool('has_completed_survey') ?? false;

    if (email != null) {
      // Verificar en la base de datos SQLite el estado real
      final dbUser = await DatabaseHelper.instance.loginUser(email, '');

      _user = User(
        email: email,
        password: '', // No guardamos la contraseña en SharedPreferences
        name: name,
        avatarPath: avatarPath,
        memberSince: memberSince != null ? DateTime.parse(memberSince) : null,
        hasCompletedSurvey: dbUser?.hasCompletedSurvey ?? hasCompletedSurvey,
      );
      notifyListeners();
    }
  }

  Future<void> setUser(User user) async {
    _user = user;
    await _saveUserToPrefs(user); // Guarda también en SharedPreferences
    notifyListeners();
  }

  Future<void> _saveUserToPrefs(User user) async {
    await _prefs.setString('user_email', user.email);
    if (user.name != null) {
      await _prefs.setString('user_name', user.name!);
    } else {
      await _prefs.remove('user_name');
    }
    if (user.avatarPath != null) {
      await _prefs.setString('user_avatar', user.avatarPath!);
    } else {
      await _prefs.remove('user_avatar');
    }
    await _prefs.setBool(
      'has_completed_survey',
      user.hasCompletedSurvey,
    ); // Nuevo
    notifyListeners();
  }

  Future<void> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    final dbHelper = DatabaseHelper.instance;

    // Verificar si el email ya existe
    final existingUser = await dbHelper.loginUser(email, password);
    if (existingUser != null) {
      throw Exception('El correo electrónico ya está registrado');
    }

    // Crear nuevo usuario
    final newUser = User(
      email: email,
      password: password, // Será hasheado en DatabaseHelper
      name: name,
      avatarPath: 'assets/images/FotoPerfil.jpeg',
      memberSince: DateTime.now(),
    );

    // Guardar en SQLite
    final userId = await dbHelper.createUser(newUser);

    if (userId > 0) {
      // Actualizar el ID y establecer el usuario
      await setUser(newUser.copyWith(id: userId));
    } else {
      throw Exception('Error al registrar el usuario');
    }
  }

  Future<void> updateSurveyCompletion(bool completed) async {
    if (_user == null) return;

    final updatedUser = _user!.copyWith(hasCompletedSurvey: completed);

    // Actualizar en SharedPreferences
    await _prefs.setBool('has_completed_survey', completed);

    // Actualizar en SQLite
    await DatabaseHelper.instance.updateSurveyCompletion(
      email: updatedUser.email,
      completed: completed,
    );

    _user = updatedUser;
    notifyListeners();
  }

  Future<void> updateProfile({String? name, String? avatarPath}) async {
    if (_user == null) return;

    final updatedUser = _user!.copyWith(name: name, avatarPath: avatarPath);

    // Guardar en SharedPreferences
    await _saveUserToPrefs(updatedUser);

    // Guardar en SQLite
    await DatabaseHelper.instance.updateUserProfile(
      email: updatedUser.email,
      name: updatedUser.name,
      avatarPath: updatedUser.avatarPath,
    );

    _user = updatedUser;
    notifyListeners();
  }

  Future<void> logout() async {
    await _prefs.clear();
    _user = null;
    notifyListeners();
  }
}
