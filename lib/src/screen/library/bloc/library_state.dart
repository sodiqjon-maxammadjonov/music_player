part of 'library_bloc.dart';

@immutable
sealed class LibraryState {}

sealed class LibraryActionsState extends LibraryState{}

final class LibraryInitial extends LibraryState {}

final class LibraryLoadingState extends LibraryActionsState {}

final class LibraryLoadedState extends LibraryActionsState {
  final List<SongModel> music;
  LibraryLoadedState({required this.music});
}

final class LibraryEmptyState extends LibraryActionsState {}

final class LibraryErrorState extends LibraryActionsState {
  final String message;
  LibraryErrorState({required this.message});
}
