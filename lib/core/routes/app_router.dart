import 'package:flutter/material.dart';
import 'package:cina/screens/home/home_screen.dart';
import 'package:cina/screens/search/search_screen.dart';
import 'package:cina/screens/post/post_screen.dart';
import 'package:cina/screens/profile/profile_screen.dart';
import 'package:cina/screens/auth/login_screen.dart';
import 'package:cina/screens/auth/register_screen.dart';
import 'package:cina/screens/auth/auth_wrapper.dart';
import 'package:cina/screens/trip/trip_screen.dart';
import 'package:cina/screens/map/map_screen.dart';
import 'package:cina/screens/onboarding/onboarding_screen.dart';
import 'package:cina/screens/onboarding/questions_screen.dart';
import 'package:cina/screens/onboarding/location_screen.dart';
import 'package:cina/screens/onboarding/app_intro_screen.dart';

class AppRouter {
  // Auth routes
  static const String authWrapper = '/';
  static const String login = '/login';
  static const String register = '/register';
  
  // Main app routes
  static const String home = '/home';
  static const String search = '/search';
  static const String post = '/post';
  static const String profile = '/profile';
  static const String trip = '/trip';
  static const String map = '/map';
  
  // Onboarding routes
  static const String onboarding = '/onboarding';
  static const String questions = '/questions';
  static const String location = '/location';
  static const String appIntro = '/app-intro';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Auth routes
      case authWrapper:
        return MaterialPageRoute(builder: (_) => const AuthWrapper());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
        
      // Main app routes
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case post:
        return MaterialPageRoute(builder: (_) => const PostScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case trip:
        return MaterialPageRoute(builder: (_) => const TripScreen());
      case map:
        return MaterialPageRoute(builder: (_) => const MapScreen());
        
      // Onboarding routes
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case questions:
        return MaterialPageRoute(builder: (_) => const QuestionsScreen());
      case location:
        return MaterialPageRoute(builder: (_) => const LocationScreen());
      case appIntro:
        return MaterialPageRoute(builder: (_) => const AppIntroScreen());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
  
  // Helper method for navigation
  static void navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }
  
  // Helper method for navigation with replacement
  static void navigateToReplacement(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
  }
  
  // Helper method for navigation with removal of all previous routes
  static void navigateAndRemoveUntil(BuildContext context, String routeName) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      (Route<dynamic> route) => false,
    );
  }
}
