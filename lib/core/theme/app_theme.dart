import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Asosiy ranglar
    colorScheme: ColorScheme.light(
      primary: Color(0xFF3A86FF),       // Asosiy ko'k rang
      onPrimary: Colors.white,          // Asosiy rang ustidagi matn rangi
      primaryContainer: Color(0xFF90C8FF),  // Asosiy rang konteyner
      onPrimaryContainer: Color(0xFF001F54), // Konteyner ustidagi matn

      secondary: Color(0xFF8338EC),      // Ikkilamchi binafsha rang
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFDABFFF),
      onSecondaryContainer: Color(0xFF3D0072),

      tertiary: Color(0xFFFF006E),       // Uchlamchi qizil rang
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFFF8EB5),
      onTertiaryContainer: Color(0xFF57002B),

      error: Color(0xFFEF233C),          // Xato qizil rang
      onError: Colors.white,
      errorContainer: Color(0xFFFAB1B8),
      onErrorContainer: Color(0xFF5B0D18),

      background: Color(0xFFF7F9FC),     // Sof fon rang
      onBackground: Color(0xFF1C1C1E),   // Fon ustidagi matn
      surface: Color(0xFFFFFFFF),        // Yuza rang
      onSurface: Color(0xFF1C1C1E),      // Yuza ustidagi matn
    ),

    // Matn uslublari
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: Color(0xFF1C1C1E),
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1C1C1E),
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: Color(0xFF3A86FF),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: Color(0xFF333333),
      ),
    ),

    // Tugma uslublari
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF3A86FF),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // TextField uslublari
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFF0F4FF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    // Card uslublari
    cardTheme: CardTheme(
      color: Color(0xFFFFFFFF),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // AppBar uslublari
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF3A86FF),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );

  // Qorong'i tema
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.dark(
      primary: Color(0xFF90C8FF),
      onPrimary: Color(0xFF003A73),
      primaryContainer: Color(0xFF1C4E80),
      onPrimaryContainer: Color(0xFFD2E4FF),

      secondary: Color(0xFFDABFFF),
      onSecondary: Color(0xFF4E1A80),
      secondaryContainer: Color(0xFF3D0072),
      onSecondaryContainer: Color(0xFFDABFFF),

      tertiary: Color(0xFFFF8EB5),
      onTertiary: Color(0xFF57002B),
      tertiaryContainer: Color(0xFF740033),
      onTertiaryContainer: Color(0xFFFFD9E3),

      error: Color(0xFFFAB1B8),
      onError: Color(0xFF601410),
      errorContainer: Color(0xFF8C1D18),
      onErrorContainer: Color(0xFFFAB1B8),

      background: Color(0xFF121212),
      onBackground: Color(0xFFE0E0E0),
      surface: Color(0xFF1F1F1F),
      onSurface: Color(0xFFE0E0E0),
    ),

    // Matn uslublari
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: Color(0xFFE0E0E0),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: Color(0xFFE0E0E0),
      ),
    ),

    // Tugma uslublari
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF90C8FF),
        foregroundColor: Color(0xFF003A73),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // AppBar uslublari
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1C4E80),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
