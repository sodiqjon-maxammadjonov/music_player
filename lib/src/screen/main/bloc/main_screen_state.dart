part of 'main_screen_bloc.dart';

@immutable
sealed class MainScreenState {}

final class MainScreenInitial extends MainScreenState {}

final class MainScreenHomeState extends MainScreenState {}

final class MainScreenLibraryState extends MainScreenState {}

final class MainScreenFavoriteState extends MainScreenState {}