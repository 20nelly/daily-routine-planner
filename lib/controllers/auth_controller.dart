import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    if (name.isNotEmpty && email.isNotEmpty && password.length >= 6) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.userTokenKey,
        'local_token_${DateTime.now().millisecondsSinceEpoch}',
      );
      await prefs.setInt(
        AppConstants.userIdKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      await prefs.setString(AppConstants.userNameKey, name);
      await prefs.setString(AppConstants.userEmailKey, email);

      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = password.length < 6
          ? 'Password must be at least 6 characters'
          : 'Please fill all fields';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    if (email.isNotEmpty && password.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.userTokenKey,
        'local_token_${DateTime.now().millisecondsSinceEpoch}',
      );
      await prefs.setInt(AppConstants.userIdKey, 1);
      await prefs.setString(AppConstants.userNameKey, email.split('@')[0]);
      await prefs.setString(AppConstants.userEmailKey, email);

      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Invalid email or password';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.userTokenKey);
    _isLoggedIn = token != null;
    notifyListeners();
  }
}
