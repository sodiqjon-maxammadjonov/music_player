part of 'navigation_bloc.dart';

@immutable
class NavigationState {
  final NavigationTab currentTab;

  NavigationState({
    this.currentTab = NavigationTab.home,
  });

  NavigationState copyWith({
    NavigationTab? currentTab,
  }) {
    return NavigationState(
      currentTab: currentTab ?? this.currentTab,
    );
  }
}
