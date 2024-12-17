
import 'package:bloc/bloc.dart';

import '../../screen/splash/bloc/splash_screen_bloc.dart';

class SplashScreenFunction {
  final Emitter<SplashScreenState> emit;

  SplashScreenFunction({required this.emit});

  Future<void> check() async {
    await Future.delayed(const Duration(seconds: 3));
    emit(SplashScreenSuccessState());
  }
}