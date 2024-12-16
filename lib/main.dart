import 'package:flutter/material.dart';
import 'package:music_player/src/route/routes.dart';
import 'package:music_player/src/screen/splash/splash_screen.dart';
import 'package:music_player/src/util/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      // initialRoute: RouteNames.splash,
      home: SplashScreen(),
    );
  }
}
