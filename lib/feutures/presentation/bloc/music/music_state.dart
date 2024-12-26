part of 'music_bloc.dart';


@immutable
class MusicState {
  final List<SongEntity> songs;
  final SongEntity? currentSong;
  final bool isPlaying;
  final bool isLoading;
  final String? error;
  final Duration? currentPosition;
  final bool isShuffleEnabled;
  final RepeatMode repeatMode;
  final double volume;

  const MusicState({
    this.songs = const [],
    this.currentSong,
    this.isPlaying = false,
    this.isLoading = false,
    this.error,
    this.currentPosition,
    this.isShuffleEnabled = false,
    this.repeatMode = RepeatMode.off,
    this.volume = 1.0,
  });

  MusicState copyWith({
    List<SongEntity>? songs,
    SongEntity? currentSong,
    bool? isPlaying,
    bool? isLoading,
    String? error,
    Duration? currentPosition,
    bool? isShuffleEnabled,
    RepeatMode? repeatMode,
    double? volume,
  }) {
    return MusicState(
      songs: songs ?? this.songs,
      currentSong: currentSong ?? this.currentSong,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentPosition: currentPosition ?? this.currentPosition,
      isShuffleEnabled: isShuffleEnabled ?? this.isShuffleEnabled,
      repeatMode: repeatMode ?? this.repeatMode,
      volume: volume ?? this.volume,
    );
  }
}
