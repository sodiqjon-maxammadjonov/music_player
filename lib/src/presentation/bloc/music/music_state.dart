part of 'music_bloc.dart';

@immutable
sealed class MusicState {}

sealed class MusicActionState {}

final class MusicLoadedState extends MusicState {
  final List<Song> song;
  MusicLoadedState({required this.song});
}

final class MusicErrorState extends MusicState {
  final String message;
  MusicErrorState({required this.message});
}

final class MusicEmptyState extends MusicState {}

final class MusicFailedState extends MusicActionState {}