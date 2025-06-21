import 'package:flutter/material.dart';
import 'package:servicios_de_modelaje3d/models/plan_data.dart';
import 'package:servicios_de_modelaje3d/services/database_helper.dart';

class PlanProvider with ChangeNotifier {
  List<PlanData> _plans = [];
  List<PlanData> _favorites = [];

  List<PlanData> get plans => _plans;
  List<PlanData> get favorites => _favorites;

  bool _isLoading = false;

  PlanProvider() {
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    if (_isLoading) return;
    _isLoading = true;
    try {
      final db = DatabaseHelper.instance;
      _plans = await db.getPlans();
      notifyListeners();
    } finally {
      _isLoading = false;
    }
  }

  Future<void> addPlan(PlanData plan) async {
    final db = DatabaseHelper.instance;
    await db.createPlan(plan);
    await _loadPlans();
  }

  Future<void> updatePlan(PlanData plan) async {
    final db = DatabaseHelper.instance;
    await db.updatePlan(plan);
    await _loadPlans();
  }

  Future<void> deletePlan(int id) async {
    final db = DatabaseHelper.instance;
    await db.deletePlan(id);
    await _loadPlans();
  }

  void addToFavorites(PlanData plan) {
    if (!_favorites.contains(plan)) {
      _favorites.add(plan);
      notifyListeners();
    }
  }

  void removeFromFavorites(PlanData plan) {
    _favorites.remove(plan);
    notifyListeners();
  }
}
