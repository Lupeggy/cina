import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static String get supabaseUrl => dotenv.get('SUPABASE_URL');
  static String get supabaseAnonKey => dotenv.get('SUPABASE_ANON_KEY');
  static String get androidClientId => dotenv.get('ANDROID_CLIENT_ID');
  
  static String get googleRedirectUrl => 
      'com.googleusercontent.apps.173190381746-apabqlfhvnem0q0jfaeum1tnp95p6a5e://login-callback';
}
