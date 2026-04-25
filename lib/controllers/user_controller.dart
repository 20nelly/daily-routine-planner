import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class UserController extends ChangeNotifier {
  String _userName = '';
  String _userEmail = '';
  bool _isLoading = true;

  String get userName => _userName;
  String get userEmail => _userEmail;
  bool get isLoading => _isLoading;

  UserController() {
    loadUserData();
  }

  Future<void> loadUserData() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString(AppConstants.userNameKey) ?? 'User';
    _userEmail =
        prefs.getString(AppConstants.userEmailKey) ?? 'user@example.com';

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUserName(String newName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userNameKey, newName);
    _userName = newName;
    notifyListeners();
  }
}
