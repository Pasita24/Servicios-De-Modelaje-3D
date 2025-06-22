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

  Future<void> _loadUserFromPrefs() async {
    final email = _prefs.getString('user_email');
    final name = _prefs.getString('user_name');
    final avatarPath = _prefs.getString('user_avatar');
    final memberSince = _prefs.getString('user_member_since');

    if (email != null) {
      _user = User(
        email: email,
        password: '', // No guardamos la contraseña en SharedPreferences
        name: name,
        avatarPath: avatarPath,
        memberSince: memberSince != null ? DateTime.parse(memberSince) : null,
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
