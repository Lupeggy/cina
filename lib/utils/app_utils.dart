import 'package:shared_preferences/shared_preferences.dart';

class AppUtils {
  // Reset all app data (for development/testing)
  static Future<void> resetApp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Check if it's the first app launch
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('first_launch') ?? true;
  }

  // Mark first launch as complete
  static Future<void> setFirstLaunchComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_launch', false);
  }

  // Get app version
  static String get appVersion {
    return '1.0.0'; // TODO: Get from pubspec.yaml
  }

  // Format date
  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
