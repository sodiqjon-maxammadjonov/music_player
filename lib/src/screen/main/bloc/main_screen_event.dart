part of 'main_screen_bloc.dart';

@immutable
sealed class MainScreenEvent {}

final class MainScreenSwitchEvent extends MainScreenEvent {
  final int index;
  MainScreenSwitchEvent({required this.index});
}