part of 'audio_player_bloc.dart';

@immutable
abstract class AudioPlayerEvent {}

class LoadSongs extends AudioPlayerEvent {}
class PlaySong extends AudioPlayerEvent {
  final Song song;
  PlaySong(this.song);
}
class PauseSong extends AudioPlayerEvent {}
class NextSong extends AudioPlayerEvent {}
class PreviousSong extends AudioPlayerEvent {}
