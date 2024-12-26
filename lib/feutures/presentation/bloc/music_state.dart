part of 'music_bloc.dart';

@immutable
 class MusicState {
  final List<SongEntity> songs;
  final SongEntity? currentSong;
  final bool isPlaying;
  final bool isLoading;
  final String? error;

  MusicState({
    this.songs = const [],
    this.currentSong,
    this.isPlaying = false,
    this.isLoading = false,
    this.error,
  });

  MusicState copyWith({
    List<SongEntity>? songs,
    SongEntity? currentSong,
    bool? isPlaying,
    bool? isLoading,
    String? error,
  }) {
    return MusicState(
      songs: songs ?? this.songs,
      currentSong: currentSong ?? this.currentSong,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
