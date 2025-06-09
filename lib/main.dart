import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/post/post_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/trip/trip_screen.dart';
import 'screens/map/map_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CINA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Use system theme mode
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/search': (context) => const SearchScreen(),
        '/post': (context) => const PostScreen(),
        '/trip': (context) => const TripScreen(),
        '/map': (context) => const MapScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
