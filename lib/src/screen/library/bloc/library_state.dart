part of 'library_bloc.dart';

@immutable
sealed class LibraryState {}

sealed class LibraryActionsState extends LibraryState{}

final class LibraryInitial extends LibraryState {}

final class LibraryLoadingState extends LibraryActionsState {}

final class LibraryLoadedState extends LibraryActionsState {}

final class LibraryEmptyState extends LibraryActionsState {}

final class LibraryNoPermissionState extends LibraryActionsState {}

final class LibraryErrorState extends LibraryActionsState {}
