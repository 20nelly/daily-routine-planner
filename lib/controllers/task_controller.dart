import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class TaskController extends ChangeNotifier {
  List<Map<String, dynamic>> _tasks = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get tasks => _tasks;
  bool get isLoading => _isLoading;

  TaskController() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString(AppConstants.tasksListKey);

    if (tasksJson != null) {
      final List<dynamic> decoded = jsonDecode(tasksJson);
      _tasks = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      // Sample tasks
      _tasks = [
        {
          'id': 1,
          'title': 'Complete project report',
          'description': 'Finish the quarterly report',
          'deadline': DateTime.now()
              .add(const Duration(days: 1))
              .toIso8601String(),
          'category': 'Work',
          'isCompleted': false,
        },
        {
          'id': 2,
          'title': 'Morning workout',
          'description': '30 minutes cardio',
          'deadline': DateTime.now().toIso8601String(),
          'category': 'Health',
          'isCompleted': false,
        },
        {
          'id': 3,
          'title': 'Buy groceries',
          'description': 'Milk, eggs, bread',
          'deadline': DateTime.now().toIso8601String(),
          'category': 'Personal',
          'isCompleted': false,
        },
      ];
      await saveTasks();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksJson = jsonEncode(_tasks);
    await prefs.setString(AppConstants.tasksListKey, tasksJson);
  }

  Future<void> addTask(Map<String, dynamic> task) async {
    task['id'] = DateTime.now().millisecondsSinceEpoch;
    task['isCompleted'] = false;
    _tasks.add(task);
    await saveTasks();
    notifyListeners();
  }

  Future<void> toggleTaskStatus(int taskId) async {
    final index = _tasks.indexWhere((task) => task['id'] == taskId);
    if (index != -1) {
      _tasks[index]['isCompleted'] = !_tasks[index]['isCompleted'];
      await saveTasks();
      notifyListeners();
    }
  }

  Future<void> deleteTask(int taskId) async {
    _tasks.removeWhere((task) => task['id'] == taskId);
    await saveTasks();
    notifyListeners();
  }

  List<Map<String, dynamic>> get pendingTasks {
    return _tasks.where((task) => task['isCompleted'] == false).toList();
  }

  List<Map<String, dynamic>> get completedTasks {
    return _tasks.where((task) => task['isCompleted'] == true).toList();
  }

  List<Map<String, dynamic>> getTasksByCategory(String category) {
    return _tasks.where((task) => task['category'] == category).toList();
  }

  List<Map<String, dynamic>> getTasksForDate(DateTime date) {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return _tasks.where((task) {
      final taskDate = task['deadline'].toString().split('T')[0];
      return taskDate == dateStr;
    }).toList();
  }
}
