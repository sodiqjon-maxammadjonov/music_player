import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/src/route/routes.dart';
import 'package:music_player/src/screen/library/bloc/library_bloc.dart';
import 'package:music_player/src/util/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LibraryBloc(),
      child: MaterialApp(
        title: 'Melody',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routes: Routes.baseRoutes,
        initialRoute: RouteNames.splash,
        // home: SplashScreen(),
      ),
    );
  }
}