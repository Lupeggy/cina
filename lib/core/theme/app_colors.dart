import 'package:flutter/material.dart';

class AppColors {
  // Gradients
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6200EE),
      Color(0xFF3700B3),
    ],
  );
  
  static const Gradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF03DAC6),
      Color(0xFF018786),
    ],
  );
  // Primary Colors
  static const Color primary = Color(0xFF6200EE);
  static const Color primaryDark = Color(0xFF3700B3);
  static const Color primaryLight = Color(0xFFBB86FC);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryDark = Color(0xFF018786);
  static const Color secondaryLight = Color(0xFF60F6F1);
  
  // Background & Surface
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFB00020);
  
  // Text Colors
  static const Color textPrimary = Color(0xDE000000); // 87% opacity
  static const Color textSecondary = Color(0x99000000); // 60% opacity
  static const Color textHint = Color(0x61000000); // 38% opacity
  static const Color textOnPrimary = Colors.white;
  static const Color textOnSecondary = Colors.black;
  static const Color textOnBackground = Color(0xDE000000);
  static const Color textOnSurface = Color(0xDE000000);
  
  // Other Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0x1F000000);
  static const Color disabled = Color(0x61000000);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkError = Color(0xFFCF6679);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xB3FFFFFF);
  static const Color darkTextHint = Color(0x80FFFFFF);
  static const Color darkBorder = Color(0x1FFFFFFF);
  static const Color darkDivider = Color(0x1FFFFFFF);
}
