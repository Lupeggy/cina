import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _preferencesKey = 'user_preferences';

  // Check if onboarding is complete
  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  // Mark onboarding as complete
  static Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
  }

  // Reset onboarding (for testing/development)
  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingCompleteKey);
    await prefs.remove(_preferencesKey);
  }

  // Save user preferences
  static Future<void> saveUserPreferences(Map<String, dynamic> preferences) async {
    final prefs = await SharedPreferences.getInstance();
    // Convert preferences to string map
    final stringMap = preferences.map((key, value) => MapEntry(key, value.toString()));
    await prefs.setString(_preferencesKey, stringMap.toString());
  }

  // Get user preferences
  static Future<Map<String, String>> getUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final prefsString = prefs.getString(_preferencesKey);
    if (prefsString == null) return {};
    
    // Parse the string back to a map
    try {
      final map = <String, String>{};
      final entries = prefsString.substring(1, prefsString.length - 1).split(', ');
      for (final entry in entries) {
        final parts = entry.split(': ');
        if (parts.length == 2) {
          map[parts[0]] = parts[1];
        }
      }
      return map;
    } catch (e) {
      return {};
    }
  }
}
