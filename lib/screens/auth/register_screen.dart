import 'package:flutter/material.dart';
import 'package:cina/core/routes/app_router.dart';
import 'package:cina/widgets/auth/auth_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: AuthForm(
            isLogin: false,
            onSubmit: (email, password) async {
              // Show loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
              
              // Simulate network delay
              await Future.delayed(const Duration(seconds: 1));
              
              // Close loading indicator and navigate to home
              if (context.mounted) {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(AppRouter.home);
              }
            },
          ),
        ),
      ),
    );
  }
}
