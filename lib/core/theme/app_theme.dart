import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData themeData = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF1A1A2E),
    scaffoldBackgroundColor: const Color(0xFF16213E),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF0F3460),
      secondary: Color(0xFFE94560),
      surface: Color(0xFF1A1A2E),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),
    fontFamily: 'Poppins', // Assuming Poppins is added to the project

    cardTheme: const CardThemeData(
      color: Color(0xFF1A1A2E),
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white70),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white60),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF0F3460),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.white38),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFFE94560),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFE94560),
      foregroundColor: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  );
}
