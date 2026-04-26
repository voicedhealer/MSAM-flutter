import 'package:flutter/material.dart';

class AppColors {
  static const autoPrimary = Color(0xFF1A1F2E);
  static const autoPrimaryLight = Color(0xFF2A3244);
  static const autoAccent = Color(0xFF3B82F6);
  static const autoAccentHover = Color(0xFF2563EB);
  static const autoSuccess = Color(0xFF10B981);
  static const autoWarning = Color(0xFFF59E0B);
  static const autoSurface = Color(0xFFFFFFFF);
  static const autoSurfaceElevated = Color(0xFFF8F9FA);
  static const autoTextPrimary = Color(0xFF1A1F2E);
  static const autoTextSecondary = Color(0xFF6B7280);
  static const autoTextHint = Color(0xFF9CA3AF);
  static const autoBorder = Color(0xFFE5E7EB);
  static const autoBorderFocus = Color(0xFF3B82F6);
}

class AppTheme {
  static const radiusInput = 12.0;
  static const radiusCard = 16.0;
  static const radiusButton = 12.0;

  static const spacingXs = 8.0;
  static const spacingSm = 12.0;
  static const spacingMd = 16.0;
  static const spacingLg = 24.0;
  static const spacingXl = 32.0;
  static const spacing2Xl = 48.0;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.autoSurface,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.light(
        primary: AppColors.autoAccent,
        secondary: AppColors.autoPrimaryLight,
        surface: AppColors.autoSurface,
        error: Colors.red,
      ),
    );
  }
}
