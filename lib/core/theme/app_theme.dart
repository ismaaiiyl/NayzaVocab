import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Core Colors
  static const Color darkNavy = Color(0xFF0A192F);
  static const Color electricGold = Color(0xFFFFD700);
  static const Color surfaceNavy = Color(0xFF112240);
  static const Color textMain = Colors.white;
  static const Color textDim = Color(0xFF94A3B8);
  static const Color cardDark = Color(0xFF1E2D4A);
  static const Color borderNavy = Color(0xFF233554);

  // Semantic Colors
  static const Color success = Color(0xFF00E676);
  static const Color error = Color(0xFFFF5252);
  static const Color info = Color(0xFF40C4FF);
  static const Color warning = Color(0xFFFFAB40);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkNavy,
      primaryColor: electricGold,
      colorScheme: ColorScheme.fromSeed(
        seedColor: electricGold,
        brightness: Brightness.dark,
        surface: surfaceNavy,
        onSurface: textMain,
        primary: electricGold,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          fontSize: 48,
          fontWeight: FontWeight.w800,
          color: electricGold,
          letterSpacing: 2,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: electricGold,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textMain,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: textMain,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: textDim,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkNavy,
        foregroundColor: electricGold,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: electricGold,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: const CardThemeData(
        color: surfaceNavy,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: AppTheme.borderNavy, width: 1),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: electricGold,
        foregroundColor: darkNavy,
        elevation: 6,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: electricGold,
          foregroundColor: darkNavy,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: surfaceNavy,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: electricGold, width: 2),
        ),
        hintStyle: TextStyle(color: textDim),
        labelStyle: TextStyle(color: electricGold),
      ),
    );
  }
}
