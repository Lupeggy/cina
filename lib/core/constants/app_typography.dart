import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  // Display text styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 45.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.16,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.22,
  );

  // Headline text styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.29,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.33,
  );

  // Title text styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.27,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.33,
    letterSpacing: 0.1,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
    letterSpacing: 0.1,
  );

  // Label text styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.43,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.33,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.45,
    letterSpacing: 0.5,
  );

  // Body text styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
    letterSpacing: 0.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.43,
    letterSpacing: 0.25,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
    letterSpacing: 0.4,
  );

  // Button text styles
  static const TextStyle button = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
    letterSpacing: 0.5,
    height: 1.5,
  );

  // Caption text styles
  static const TextStyle caption = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 0.4,
    height: 1.33,
  );

  // Overline text styles
  static const TextStyle overline = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
    height: 1.6,
  );

  // Helper methods for text themes
  static TextTheme get textTheme {
    return const TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
  }

  static TextTheme get primaryTextTheme {
    return TextTheme(
      displayLarge: displayLarge.copyWith(color: AppColors.textOnPrimary),
      displayMedium: displayMedium.copyWith(color: AppColors.textOnPrimary),
      displaySmall: displaySmall.copyWith(color: AppColors.textOnPrimary),
      headlineLarge: headlineLarge.copyWith(color: AppColors.textOnPrimary),
      headlineMedium: headlineMedium.copyWith(color: AppColors.textOnPrimary),
      headlineSmall: headlineSmall.copyWith(color: AppColors.textOnPrimary),
      titleLarge: titleLarge.copyWith(color: AppColors.textOnPrimary),
      titleMedium: titleMedium.copyWith(color: AppColors.textOnPrimary),
      titleSmall: titleSmall.copyWith(color: AppColors.textOnPrimary),
      bodyLarge: bodyLarge.copyWith(color: AppColors.textOnPrimary),
      bodyMedium: bodyMedium.copyWith(color: AppColors.textOnPrimary),
      bodySmall: bodySmall.copyWith(color: AppColors.textOnPrimary.withOpacity(0.8)),
      labelLarge: labelLarge.copyWith(color: AppColors.textOnPrimary),
      labelMedium: labelMedium.copyWith(color: AppColors.textOnPrimary),
      labelSmall: labelSmall.copyWith(color: AppColors.textOnPrimary),
    );
  }
}
