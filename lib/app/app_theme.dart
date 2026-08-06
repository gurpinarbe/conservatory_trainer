import 'package:flutter/material.dart';

abstract final class AppTheme {
  static final ColorScheme _colorScheme =
      ColorScheme.fromSeed(
        seedColor: const Color(0xFF1F6A52),
        brightness: Brightness.light,
      ).copyWith(
        secondary: const Color(0xFFD79A31),
        surface: const Color(0xFFFFFBF5),
      );

  static ThemeData get lightTheme {
    // Tema ayarlarını tek noktada toplayarak yeni ekranların
    // aynı Material 3 diliyle gelmesini sağlıyoruz.
    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF3EFE7),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: _colorScheme.primary,
        contentTextStyle: TextStyle(
          color: _colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          side: BorderSide(color: _colorScheme.primary.withValues(alpha: 0.20)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
