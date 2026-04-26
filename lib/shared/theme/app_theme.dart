import 'package:flutter/material.dart';

class AppColors {
  static const autoPrimary = Color(0xFF1A1F2E);
  static const autoPrimaryLight = Color(0xFF2A3244);
  static const autoAccent = Color(0xFF3B82F6);
  static const autoAccentPurple = Color(0xFF7C3AED);
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
        secondary: AppColors.autoAccentPurple,
        surface: AppColors.autoSurface,
        error: Colors.red,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.dark(
        primary: AppColors.autoAccent,
        secondary: AppColors.autoAccentPurple,
        surface: Color(0xFF111827),
        error: Colors.redAccent,
      ),
    );
  }

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color surface(BuildContext context) =>
      isDark(context) ? const Color(0xFF0F172A) : AppColors.autoSurface;

  static Color surfaceElevated(BuildContext context) =>
      isDark(context) ? const Color(0xFF111827) : AppColors.autoSurfaceElevated;

  static Color textPrimary(BuildContext context) =>
      isDark(context) ? const Color(0xFFF8FAFC) : AppColors.autoTextPrimary;

  static Color textSecondary(BuildContext context) =>
      isDark(context) ? const Color(0xFFCBD5E1) : AppColors.autoTextSecondary;

  static Color textHint(BuildContext context) =>
      isDark(context) ? const Color(0xFF94A3B8) : AppColors.autoTextHint;

  static Color border(BuildContext context) =>
      isDark(context) ? const Color(0xFF334155) : AppColors.autoBorder;

  static Color borderFocus(BuildContext context) =>
      isDark(context) ? const Color(0xFF60A5FA) : AppColors.autoBorderFocus;

  static LinearGradient get appBackgroundGradient {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.autoAccent.withValues(alpha: 0.08),
        AppColors.autoAccentPurple.withValues(alpha: 0.08),
        AppColors.autoSurface,
      ],
    );
  }

  static const LinearGradient ctaGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      AppColors.autoAccent,
      AppColors.autoAccentPurple,
    ],
  );
}
