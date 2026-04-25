/*class AppConstants {
  // For local development (same computer)
  static const String baseUrl = 'http://localhost/routine_app/api';
  static const String sharedPrefsKey = 'tasks_list';
  // If you want to test on another device on same network, use your IP:
  // static const String baseUrl = 'http://192.168.100.116/routine_app/api';

  // API Endpoints
  static const String login = '$baseUrl/login.php';
  static const String register = '$baseUrl/register.php';
  static const String getTasks = '$baseUrl/get_tasks.php';
  static const String createTask = '$baseUrl/create_task.php';
  static const String updateTask = '$baseUrl/update_task.php';
  static const String deleteTask = '$baseUrl/delete_task.php';
  static const String getProfile = '$baseUrl/get_profile.php';
  static const String updateProfile = '$baseUrl/update_profile.php';
}
*/
class AppConstants {
  // Shared Preferences Keys
  static const String tasksListKey = 'tasks_list';
  static const String userTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String userEmailKey = 'user_email';

  // App Info
  static const String appName = 'Daily Routine Planner';
  static const String appVersion = '1.0.0';

  // Task Categories
  static const List<String> categories = ['Work', 'Personal', 'Health'];
}
