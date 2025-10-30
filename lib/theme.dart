import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Palette from HTML
  static const Color primary = Color(0xFFD46F11); // Primary orange-brown
  static const Color backgroundLight = Color(0xFFF8F7F6); // Background light
  static const Color backgroundDark = Color(0xFF221910); // Background dark
  static const Color textPrimary = Color(0xFF181411); // Text primary
  static const Color textSecondary = Color(0xFF897561); // Text secondary

  // Legacy colors for compatibility
  static const Color primaryBrown = Color(0xFF7C5E3A);
  static const Color secondaryBrown = Color(0xFFA67B5B);
  static const Color lightCream = Color(0xFFFAF8EE);
  static const Color naturalGreen = Color(0xFF4CAF50);
  static const Color darkGreen = Color(0xFF2E7D32);

  // New Splash Colors
  static const Color earthyBrown = Color(0xFF654321);
  static const Color leafyGreen = Color(0xFF2E8B57);
  static const Color beige = Color(0xFFF5F5DC);
  static const Color sandyBrown = Color(0xFFD2B48C);

  // Typography
  static TextTheme textTheme = GoogleFonts.nunitoTextTheme();

  // Theme Data
  static ThemeData get theme => ThemeData(
    primaryColor: primaryBrown,
    scaffoldBackgroundColor: const Color(0xFFECE9E6),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBrown,
      primary: primaryBrown,
      secondary: naturalGreen,
      surface: lightCream,
    ),
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryBrown,
      foregroundColor: Colors.white,
      titleTextStyle: textTheme.headlineSmall?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryBrown, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.1),
    ),
  );

  // Constants
  static const double defaultPadding = 20.0;
  static const double cardRadius = 12.0;
  static const double buttonRadius = 12.0;
}
