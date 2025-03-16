import 'package:flutter/material.dart';

class Common {
  // Light Theme
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2ECC71),
      secondary: Color(0xFF489797),
      surface: Color(0xFFF5F5F5),
      onSurface: Color(0xFF141414),
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    textTheme: _getTextTheme(Colors.black),
    inputDecorationTheme: _getInputDecorationTheme(const Color(0xFF8391A1)),
  );

  // Dark Theme
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF2ECC71),
      secondary: Color(0xFF6AB7B7),
      surface: Color(0xFF141414),
      surfaceContainer: Color(0xFF282828),
      onSurface: Color(0xFFF5F5F5),
    ),
    scaffoldBackgroundColor: const Color(0xFF141414),
    textTheme: _getTextTheme(Colors.white),
    inputDecorationTheme: _getInputDecorationTheme(const Color(0xFFA0B0C0)),
  );

  // Common Text Theme
  static TextTheme _getTextTheme(Color textColor) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 30,
        fontFamily: "Urbanist",
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      bodyMedium: const TextStyle(
        fontSize: 15,
        fontFamily: "Urbanist-Bold",
        fontWeight: FontWeight.bold,
        color: Color(0xFFFFFFFF),
      ),
      bodySmall: const TextStyle(
        fontSize: 16,
        fontFamily: "Urbanist-Bold",
        fontWeight: FontWeight.w300,
        color: Colors.grey,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontFamily: "Urbanist-SemiBold",
        color: textColor,
      ),
      labelLarge: const TextStyle(
        fontSize: 15,
        fontFamily: "Urbanist-SemiBold",
        fontWeight: FontWeight.bold,
        color: Color(0xFFF5F5F5),
      ),
    );
  }

  // Common Input Decoration Theme
  static InputDecorationTheme _getInputDecorationTheme(Color hintColor) {
    return InputDecorationTheme(
      hintStyle: TextStyle(
        fontSize: 15,
        fontFamily: 'Urbanist-Medium',
        color: hintColor,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: hintColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFFFFFFF)),
      ),
    );
  }
}