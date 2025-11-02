import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2F3C4C);
  static const Color secondary = Color(0xFF4E7D96);
  static const Color accent = Color(0xFF2CB67D);
  static const Color danger = Color(0xFFE24A4A);
  static const Color warning = Color(0xFFF5A524);
  static const Color info = Color(0xFF4AA3DF);
  static const Color success = Color(0xFF2CB67D);
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Colors.white;
  static const Color onPrimary = Colors.white;
  static const Color onSurface = Color(0xFF2F3C4C);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData.light();
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.background, // Changed from background to surface
      onPrimary: AppColors.onPrimary,
      onSecondary: Colors.white,
      onSurface: AppColors.onSurface,
      error: AppColors.danger,
      onError: Colors.white,
    );

    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: Color(0xFFE3E7ED)),
    );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD3D9E3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD3D9E3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
        labelStyle: const TextStyle(color: AppColors.onSurface),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary,
        secondarySelectedColor: AppColors.secondary,
        labelStyle: const TextStyle(color: AppColors.onSurface),
        secondaryLabelStyle: const TextStyle(color: AppColors.onPrimary),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        shape: cardShape,
      ),
      dividerColor: const Color(0xFFE3E7ED),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppColors.primary),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
      ),
    );
  }
}
