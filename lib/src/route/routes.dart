import 'package:flutter/material.dart';
import 'package:music_player/src/screen/splash/splash_screen.dart';
class RouteNames {
  static const String home = '/';
  static const String splash = '/splash';
}

class Routes {
  static final Map<String, WidgetBuilder> baseRoutes = {
    RouteNames.home: (context) =>  Container(),
    RouteNames.splash: (context) =>  SplashScreen(),
  };
}