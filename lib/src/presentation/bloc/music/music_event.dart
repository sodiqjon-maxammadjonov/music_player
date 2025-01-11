part of 'music_bloc.dart';

@immutable
abstract class MusicEvent {}

class MusicLoadEvent extends MusicEvent {
  final BuildContext context;

  MusicLoadEvent({required this.context});
}

class MusicPlayPauseEvent extends MusicEvent {
  final BuildContext context;
  final String path;
  final List<Song> songs;
  final int currentIndex;

  MusicPlayPauseEvent({
    required this.context,
    required this.path,
    required this.songs,
    required this.currentIndex,
  });
}
