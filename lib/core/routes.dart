import 'package:flutter/material.dart';
import '../screens/auth/auth_wrapper.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/trip/trip_screen.dart';
import '../screens/map/map_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/onboarding/questions_screen.dart';
import '../services/onboarding_service.dart';
import '../screens/onboarding/location_screen.dart';
import '../screens/onboarding/app_intro_screen.dart';
import '../screens/profile/profile_screen.dart';
import 'theme/transitions.dart';

class AppRoutes {
  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  
  // Main app routes
  static const String home = '/home';
  static const String search = '/search';
  static const String trip = '/trip';
  static const String map = '/map';
  static const String profile = '/profile';
  
  // Onboarding routes
  static const String onboarding = '/onboarding';
  static const String questions = '/questions';
  static const String location = '/location';
  static const String appIntro = '/app-intro';
  
  // Movie scene routes
  static const String movieSceneDetail = '/movie-scene-detail';
  
  // Helper method to generate route names with parameters
  static String movieSceneDetailWithId(String id) => '$movieSceneDetail?id=$id';
  
  // Get all routes
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // Main route is handled by AuthWrapper
      '/': (context) => const AuthWrapper(),
      
      // Auth routes
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      
      // Onboarding routes
      onboarding: (context) => OnboardingScreen(
        onComplete: () async {
          // Mark onboarding as complete and navigate to home
          await OnboardingService.completeOnboarding();
          if (context.mounted) {
            Navigator.of(context).pushReplacementNamed(home);
          }
        },
      ),
      questions: (context) => const QuestionsScreen(),
      location: (context) => const LocationScreen(),
      appIntro: (context) => const AppIntroScreen(),
      
      // Main app routes
      home: (context) => const HomeScreen(),
      search: (context) => const SearchScreen(),
      trip: (context) => const TripScreen(),
      map: (context) => const MapScreen(),
      profile: (context) => const ProfileScreen(),
    };
  }
  
  // Get page route with transition
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Onboarding flow with slide transition
      case onboarding:
        return SlideRightRoute(
          page: Builder(
            builder: (context) => OnboardingScreen(
              onComplete: () async {
                // Mark onboarding as complete and navigate to home
                await OnboardingService.completeOnboarding();
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed(home);
                }
              },
            ),
          ),
        );
      case questions:
        return SlideRightRoute(page: const QuestionsScreen());
      case location:
        return SlideRightRoute(page: const LocationScreen());
      case appIntro:
        return FadeRoute(page: const AppIntroScreen());
        
      // Auth routes with fade transition
      case login:
        return FadeRoute(page: const LoginScreen());
      case register:
        return FadeRoute(page: const RegisterScreen());
        
      // Main app routes with scale transition
      case home:
        return ScaleRoute(page: const HomeScreen());
      case search:
        return ScaleRoute(page: const SearchScreen());
      case trip:
        return ScaleRoute(page: const TripScreen());
      case map:
        return ScaleRoute(page: const MapScreen());
      case profile:
        return ScaleRoute(page: const ProfileScreen());
        
      // Default route (should not happen)
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
}
