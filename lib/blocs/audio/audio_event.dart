part of 'audio_bloc.dart';

@immutable
abstract class AudioEvent extends Equatable {
  const AudioEvent();

  @override
  List<Object?> get props => [];
}

class PlaySong extends AudioEvent {
  final Song song;
  final List<Song>? playlist;
  final int? playlistIndex;

  const PlaySong(this.song, {this.playlist, this.playlistIndex});

  @override
  List<Object?> get props => [song, playlist, playlistIndex];
}

class PauseSong extends AudioEvent {}
class ResumeSong extends AudioEvent {}
class StopSong extends AudioEvent {}
class SeekAudio extends AudioEvent {
  final Duration position;
  const SeekAudio(this.position);

  @override
  List<Object> get props => [position];
}

