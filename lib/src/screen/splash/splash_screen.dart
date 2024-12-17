import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/src/route/routes.dart';
import 'package:music_player/src/screen/splash/bloc/splash_screen_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenStates createState() => SplashScreenStates();
}
class SplashScreenStates extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final bloc = SplashScreenBloc();

  @override
  void initState() {
    bloc.add(SplashScreenCheckEvent());
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocConsumer<SplashScreenBloc, SplashScreenState>(
        bloc: bloc,
        listenWhen: (previous, current) => current is SplashScreenActionState,
        buildWhen: (previous, current) {
          return current is! SplashScreenActionState;
        },

        listener: (context, state) {
          if (state is SplashScreenInitial) {
          } else if (state is SplashScreenSuccessState) {
            Navigator.pushReplacementNamed(context, RouteNames.main);
          }
          else {
            Error();
          }
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.1),
                  ScaleTransition(
                    scale: Tween<double>(begin: 0.7, end: 1.2).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Curves.elasticOut,
                      ),
                    ),
                    child: Icon(
                      Icons.music_note_rounded,
                      size: 150,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TweenAnimationBuilder(
                    duration: const Duration(seconds: 2),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, opacity, child) {
                      return Opacity(
                        opacity: opacity,
                        child: Text(
                          'Melody',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.9),
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(3, 3),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: height * 0.2),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
