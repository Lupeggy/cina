import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gotrue/gotrue.dart';
import '../config/supabase_config.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  
  late final SupabaseClient _client;
  
  SupabaseService._internal() {
    _client = Supabase.instance.client;
  }
  
  SupabaseClient get client => _client;
  
  // Web Client ID that you registered with Google Cloud.
  static const String webClientId = '173190381746-apabqlfhvnem0q0jfaeum1tnp95p6a5e.apps.googleusercontent.com';
  
  // iOS Client ID that you registered with Google Cloud.
  static const String iosClientId = '173190381746-j5f04gl33p9t5lidbdek56q89veb9a5i.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: iosClientId,
    serverClientId: webClientId,
    scopes: [
      'email',
      'profile',
    ],
  );

  Future<AuthResponse> signInWithGoogle() async {
    try {
      // First, try to get the current session
      final currentSession = _client.auth.currentSession;
      if (currentSession != null) {
        return AuthResponse(
          session: currentSession,
          user: _client.auth.currentUser!,
        );
      }

      // For web, we'll use a different approach
      if (kIsWeb) {
        await _client.auth.signInWithOAuth(
          OAuthProvider.google,
          authScreenLaunchMode: LaunchMode.inAppWebView,
          redirectTo: 'io.supabase.cinachat://login-callback',
        );
        
        // Wait a bit for the redirect to complete
        await Future.delayed(const Duration(seconds: 2));
        
        // Get the current session after OAuth completes
        final session = _client.auth.currentSession;
        if (session == null) {
          throw 'No active session found after Google Sign In';
        }
        
        return AuthResponse(
          session: session,
          user: _client.auth.currentUser!,
        );
      } else {
        // For mobile/desktop
        await _client.auth.signInWithOAuth(
          OAuthProvider.google,
          authScreenLaunchMode: LaunchMode.externalApplication,
          redirectTo: 'io.supabase.cinachat://login-callback',
        );
        
        // Wait a bit for the redirect to complete
        await Future.delayed(const Duration(seconds: 2));
        
        // Get the current session after OAuth completes
        final session = _client.auth.currentSession;
        if (session == null) {
          throw 'No active session found after Google Sign In';
        }
        
        return AuthResponse(
          session: session,
          user: _client.auth.currentUser!,
        );
      }
    } catch (e) {
      print('Google Sign In Error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
  
  User? get currentUser => _client.auth.currentUser;
}
