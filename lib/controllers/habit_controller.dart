import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitController extends ChangeNotifier {
  List<Map<String, dynamic>> _habits = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get habits => _habits;
  bool get isLoading => _isLoading;

  HabitController() {
    loadHabits();
  }

  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final String? habitsJson = prefs.getString('habits_list');

    if (habitsJson != null) {
      final List<dynamic> decoded = jsonDecode(habitsJson);
      _habits = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      _habits = [
        {
          'id': 1,
          'name': 'Morning Meditation',
          'description': '10 minutes of mindfulness',
          'streak': 5,
          'isCompleted': false,
        },
        {
          'id': 2,
          'name': 'Drink Water',
          'description': 'Drink 8 glasses of water',
          'streak': 12,
          'isCompleted': false,
        },
        {
          'id': 3,
          'name': 'Read Books',
          'description': 'Read 20 pages daily',
          'streak': 3,
          'isCompleted': false,
        },
        {
          'id': 4,
          'name': 'Exercise',
          'description': '30 minutes workout',
          'streak': 7,
          'isCompleted': false,
        },
      ];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String habitsJson = jsonEncode(_habits);
    await prefs.setString('habits_list', habitsJson);
  }

  void toggleHabit(int habitId) {
    final index = _habits.indexWhere((habit) => habit['id'] == habitId);
    if (index != -1) {
      _habits[index]['isCompleted'] = !_habits[index]['isCompleted'];
      if (_habits[index]['isCompleted']) {
        _habits[index]['streak'] = (_habits[index]['streak'] ?? 0) + 1;
      }
      saveHabits();
      notifyListeners();
    }
  }

  void addHabit(String name, String description) {
    _habits.add({
      'id': DateTime.now().millisecondsSinceEpoch,
      'name': name,
      'description': description,
      'streak': 0,
      'isCompleted': false,
    });
    saveHabits();
    notifyListeners();
  }

  int get totalHabits => _habits.length;
  int get completedToday =>
      _habits.where((h) => h['isCompleted'] == true).length;
  int get activeStreaks => _habits.where((h) => h['streak'] > 0).length;
}
