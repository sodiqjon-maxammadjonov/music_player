part of 'navigation_bloc.dart';

@immutable
enum NavigationTab { home, settings }

abstract class NavigationEvent {}

class TabChanged extends NavigationEvent {
  final NavigationTab tab;
  TabChanged(this.tab);
}
