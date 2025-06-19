import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Show loading UI immediately
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );

  try {
    // Initialize the app
    await _initializeApp();
  } catch (e) {
    print('Error initializing app: $e');
    // Show error UI
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 50),
                const SizedBox(height: 20),
                const Text(
                  'Failed to initialize app',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  e.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => main(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _initializeApp() async {
  try {
    // Initialize Supabase
    await Supabase.initialize(
      url: 'https://avrbmuawhyqtisxdtnhb.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF2cmJtdWF3aHlxdGlzeGR0bmhiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAwNTQ4OTksImV4cCI6MjA2NTYzMDg5OX0.s7r66k5-rsZyu9ZyU0_Jrj8JdhcBZsdp2XqVrTBRjec',
    );

    // Run the main app
    runApp(const CinaApp());
  } catch (e) {
    print('Error in _initializeApp: $e');
    rethrow;
  }
}

class CinaApp extends StatelessWidget {
  const CinaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CINA',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRouter.authWrapper,
      onGenerateRoute: AppRouter.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}