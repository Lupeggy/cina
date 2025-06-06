import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseUtils {
  // Initialize Firebase
  static Future<void> initialize() async {
    try {
      // Initialize without options - will use GoogleService-Info.plist on iOS
      await Firebase.initializeApp();
      debugPrint('Firebase initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Firebase: $e');
      rethrow;
    }
  }

  // Handle Firebase errors
  static String getFirebaseErrorMessage(dynamic error) {
    if (error.toString().contains('firebase_auth')) {
      final errorMessage = error.toString().toLowerCase();
      
      if (errorMessage.contains('user-not-found')) {
        return 'No user found with this email.';
      } else if (errorMessage.contains('wrong-password')) {
        return 'Incorrect password. Please try again.';
      } else if (errorMessage.contains('email-already-in-use')) {
        return 'This email is already registered. Please sign in.';
      } else if (errorMessage.contains('weak-password')) {
        return 'The password provided is too weak.';
      } else if (errorMessage.contains('invalid-email')) {
        return 'The email address is not valid.';
      } else if (errorMessage.contains('operation-not-allowed')) {
        return 'Account sign-in is disabled.';
      } else if (errorMessage.contains('account-exists-with-different-credential')) {
        return 'An account already exists with the same email but different sign-in credentials.';
      } else if (errorMessage.contains('invalid-credential')) {
        return 'The credential is invalid or expired.';
      } else if (errorMessage.contains('user-disabled')) {
        return 'This user account has been disabled.';
      } else if (errorMessage.contains('requires-recent-login')) {
        return 'This operation requires recent authentication. Please sign in again.';
      } else {
        return 'An unknown authentication error occurred.';
      }
    }
    return error.toString(); 
  }
}
