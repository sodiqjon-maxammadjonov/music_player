part of 'library_bloc.dart';

@immutable
sealed class LibraryState {}

sealed class LibraryActionsState extends LibraryState{}

final class LibraryInitial extends LibraryState {}

final class LibraryLoadingState extends LibraryActionsState {}

final class LibraryNoPermissionState extends LibraryState {
  final String message;
  LibraryNoPermissionState({required this.message});
}
final class LibraryLoadedState extends LibraryState {
  final List<File> music;
  LibraryLoadedState({required this.music});
}

final class LibraryEmptyState extends LibraryState {}

final class LibraryErrorState extends LibraryState {
  final String message;
  LibraryErrorState({required this.message});
}
