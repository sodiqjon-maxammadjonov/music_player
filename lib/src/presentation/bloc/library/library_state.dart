part of 'library_bloc.dart';

@immutable
class LibraryState {
  final int currentTab;
  final bool isLoading;

  LibraryState({
    this.currentTab = 0,
    this.isLoading = false,
  });

  LibraryState copyWith({
    int? currentTab,
    bool? isLoading,
  }) {
    return LibraryState(
      currentTab: currentTab ?? this.currentTab,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
