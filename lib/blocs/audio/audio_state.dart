part of 'audio_bloc.dart';

@immutable
abstract class AudioState extends Equatable {
  const AudioState();

  @override
  List<Object?> get props => [];
}

class AudioInitial extends AudioState {}

class AudioPlaying extends AudioState {
  final Song song;
  final Duration duration;
  final Duration position;
  final List<Song>? playlist;
  final int? playlistIndex;

  const AudioPlaying(
      this.song,
      this.duration,
      this.position, {
        this.playlist,
        this.playlistIndex,
      });

  @override
  List<Object?> get props => [song, duration, position, playlist, playlistIndex];
}

class AudioPaused extends AudioState {
  final Song song;
  final Duration position;

  const AudioPaused(this.song, this.position);

  @override
  List<Object> get props => [song, position];
}

class AudioStopped extends AudioState {}

