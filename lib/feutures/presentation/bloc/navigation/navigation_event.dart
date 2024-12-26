part of 'navigation_bloc.dart';

@immutable
sealed class NavigationEvent {}

class NavigationIndexChanged extends NavigationEvent {
  final int index;
  NavigationIndexChanged(this.index);
}