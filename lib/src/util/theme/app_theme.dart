import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF6A5ACD),

    colorScheme: ColorScheme.light(
      primary: Color(0xFF6BBFFF),
      secondary: Color(0xFFFF6B6B),
      surface: Color(0xFFF5F5F5),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      error: Colors.red,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFFF5F5F5),
      foregroundColor: Color(0xFF2C3E50),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Color(0xFF2C3E50),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: Color(0xFF2C3E50),
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: Color(0xFF34495E),
        fontSize: 18,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF2C3E50),
      ),
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: Color(0xFF6A5ACD),
      inactiveTrackColor: Color(0xFFBBBBBB),
      thumbColor: Color(0xFF6A5ACD),
      overlayColor: Color(0xFF6A5ACD).withValues(alpha: 51, red: 106, green: 90, blue: 205),
    ),

    iconTheme: IconThemeData(
      color: Color(0xFF2C3E50),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF8A4FFF),
    scaffoldBackgroundColor: Color(0xFF121212),

    colorScheme: ColorScheme.dark(
      primary: Color(0xFF8A4FFF),
      secondary: Color(0xFFFF6B6B),
      background: Color(0xFF121212),
      surface: Color(0xFF1E1E1E),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: Color(0xFFB0B0B0),
        fontSize: 18,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
      ),
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: Color(0xFF8A4FFF),
      inactiveTrackColor: Color(0xFF4A4A4A),
      thumbColor: Color(0xFF8A4FFF),
      overlayColor: Color(0xFF8A4FFF).withValues(alpha: 0.3, red: 138, green: 79, blue: 255),
    ),

    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  );
}