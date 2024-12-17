part of 'splash_screen_bloc.dart';

@immutable
sealed class SplashScreenState {}

sealed class SplashScreenActionState extends SplashScreenState {}

final class SplashScreenInitial extends SplashScreenState {}

final class SplashScreenSuccessState extends SplashScreenActionState {}