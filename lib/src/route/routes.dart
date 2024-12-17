import 'package:flutter/material.dart';
import 'package:music_player/src/screen/main/main_screen.dart';
import 'package:music_player/src/screen/splash/splash_screen.dart';
class RouteNames {
  // static const String initial = '/';
  static const String main = '/main';
  static const String splash = '/splash';
}

class Routes {
  static final Map<String, WidgetBuilder> baseRoutes = {
    // RouteNames.initial: (context) => SplashScreen(),
    RouteNames.main: (context) =>  MainScreen(),
    RouteNames.splash: (context) {
      return const SplashScreen();
    },
  };
}