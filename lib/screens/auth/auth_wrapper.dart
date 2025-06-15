import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cina/core/routes/app_router.dart';
import 'package:cina/screens/onboarding/onboarding_screen.dart';
import 'package:cina/services/onboarding_service.dart';
import 'dart:io' show Platform;

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _showOnboarding = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Reset onboarding for testing
    await OnboardingService.resetOnboarding();
    
    // Check onboarding status
    await _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    try {
      print('Checking onboarding status...');
      final isComplete = await OnboardingService.isOnboardingComplete();
      print('Onboarding status: $isComplete');
      
      if (!mounted) return;
      
      if (isComplete) {
        print('Onboarding complete, navigating to register screen');
        // If onboarding is complete, navigate to register screen
        _navigateToRegister();
      } else {
        print('Showing onboarding screen');
        // Show onboarding screen
        setState(() {
          _showOnboarding = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error checking onboarding status: $e')),
        );
      }
    }
  }

  Future<void> _onOnboardingComplete() async {
    try {
      print('Onboarding completed, marking as complete');
      // Mark onboarding as complete
      await OnboardingService.completeOnboarding();
      
      // Navigate to register screen
      if (mounted) {
        print('Navigating to register screen');
        // Use pushReplacementNamed to remove the onboarding screen from the stack
        Navigator.of(context).pushReplacementNamed(AppRouter.register);
      }
    } catch (e) {
      if (mounted) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing onboarding: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _navigateToRegister() {
    if (mounted) {
      // Use pushReplacement to remove the auth wrapper from the stack
      Navigator.of(context).pushReplacementNamed(AppRouter.register);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_showOnboarding) {
      return OnboardingScreen(
        onComplete: _onOnboardingComplete,
      );
    }

    // This should not happen, but just in case
    return const Scaffold(
      body: Center(
        child: Text('Something went wrong. Please restart the app.'),
      ),
    );
  }
}
