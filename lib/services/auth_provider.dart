import 'package:flutter/material.dart';
import 'package:servicios_de_modelaje3d/models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
