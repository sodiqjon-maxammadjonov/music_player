import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Asosiy ranglar
      primaryColor: const Color(0xFF6C63FF),
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF6C63FF),
        secondary: const Color(0xFFFF6584),
        tertiary: const Color(0xFF2F2E41),
        surface: const Color(0xFFF5F5F9),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFF2F2E41),
      ),

      // AppBar Style
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2F2E41),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: const Color(0xFF2F2E41),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card Style
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
        shadowColor: const Color(0xFF6C63FF).withValues(alpha: 0.1),
      ),

      // ListTile Style
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: Colors.white,
        selectedTileColor: const Color(0xFF6C63FF).withValues(alpha: 0.1),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: const Color(0xFF6C63FF),
        size: 24,
      ),

      // Button Style
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C63FF),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Text Style
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: const Color(0xFF2F2E41),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: const Color(0xFF2F2E41),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: const Color(0xFF2F2E41),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: const Color(0xFF2F2E41),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: const Color(0xFF2F2E41),
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: const Color(0xFF2F2E41).withOpacity(0.7),
          fontSize: 14,
        ),
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: const Color(0xFF6C63FF),
        inactiveTrackColor: const Color(0xFF6C63FF).withOpacity(0.2),
        thumbColor: const Color(0xFF6C63FF),
        overlayColor: const Color(0xFF6C63FF).withOpacity(0.1),
        trackHeight: 4.0,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Asosiy ranglar
      primaryColor: const Color(0xFF8B85FF),
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF8B85FF),
        secondary: const Color(0xFFFF85A0),
        tertiary: const Color(0xFFF5F5F9),
        background: const Color(0xFF121212),
        surface: const Color(0xFF1E1E1E),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),

      // AppBar Style
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card Style
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color(0xFF1E1E1E),
        shadowColor: Colors.black.withOpacity(0.3),
      ),

      // ListTile Style
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: const Color(0xFF1E1E1E),
        selectedTileColor: const Color(0xFF8B85FF).withOpacity(0.2),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: const Color(0xFF8B85FF),
        size: 24,
      ),

      // Button Style
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B85FF),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Text Style
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 14,
        ),
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: const Color(0xFF8B85FF),
        inactiveTrackColor: const Color(0xFF8B85FF).withOpacity(0.2),
        thumbColor: const Color(0xFF8B85FF),
        overlayColor: const Color(0xFF8B85FF).withOpacity(0.1),
        trackHeight: 4.0,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
      ),
    );
  }

  // Custom Gradient Colors
  static final LinearGradient primaryGradient = LinearGradient(
    colors: [
      const Color(0xFF6C63FF),
      const Color(0xFF8B85FF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient secondaryGradient = LinearGradient(
    colors: [
      const Color(0xFFFF6584),
      const Color(0xFFFF85A0),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}