part of 'audio_player_bloc.dart';

@immutable
abstract class AudioPlayerState {}

class AudioPlayerInitial extends AudioPlayerState {}
class AudioPlayerLoading extends AudioPlayerState {}
class AudioPlayerLoaded extends AudioPlayerState {
  final List<Song> songs;
  final Song? currentSong;
  final bool isPlaying;

  AudioPlayerLoaded({
    required this.songs,
    this.currentSong,
    required this.isPlaying,
  });
}
class AudioPlayerError extends AudioPlayerState {
  final String message;
  AudioPlayerError(this.message);
}