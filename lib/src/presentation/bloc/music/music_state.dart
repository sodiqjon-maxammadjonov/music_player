part of 'music_bloc.dart';

@immutable
enum MusicPlayerStatus { initial, loading, loaded, playing, paused, error, completed }

class MusicState extends Equatable {
  final List<SongModel> songs;
  final MusicPlayerStatus status;
  final SongModel? currentSong;
  final String? errorMessage;
  final String? successMessage;
  final Duration position;
  final Duration duration;

  const MusicState({
    this.songs = const [],
    this.status = MusicPlayerStatus.initial,
    this.currentSong,
    this.errorMessage,
    this.successMessage,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  MusicState copyWith({
    List<SongModel>? songs,
    MusicPlayerStatus? status,
    SongModel? currentSong,
    String? errorMessage,
    String? successMessage,
    Duration? position,
    Duration? duration,
  }) {
    return MusicState(
      songs: songs ?? this.songs,
      status: status ?? this.status,
      currentSong: currentSong ?? this.currentSong,
      errorMessage: errorMessage,
      successMessage: successMessage,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object?> get props => [
    songs,
    status,
    currentSong,
    errorMessage,
    successMessage,
    position,
    duration
  ];
}
