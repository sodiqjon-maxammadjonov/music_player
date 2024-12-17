import 'package:flutter/material.dart';
import 'package:music_player/src/screen/main/main_screen.dart';
import 'package:music_player/src/screen/splash/splash_screen.dart';
class RouteNames {
  static const String splash = '/';
  static const String main = '/main';
}

class Routes {
  static final Map<String, WidgetBuilder> baseRoutes = {
    RouteNames.splash: (context) =>  SplashScreen(),
    RouteNames.main: (context) {
      return const MainScreen();
    },
  };
}