import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../functions/splash/splash_screen_function.dart';
part 'splash_screen_event.dart';
part 'splash_screen_state.dart';
class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc() : super(SplashScreenInitial()) {
    on<SplashScreenCheckEvent>(splashScreenCheckEvent);
  }
  FutureOr<void> splashScreenCheckEvent(
      SplashScreenCheckEvent event, Emitter<SplashScreenState> emit) async {
    await SplashScreenFunction(emit: emit).check();
  }
}