import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/song_entity.dart';
import '../../domain/repositories/music_repository.dart';
import '../../domain/usecases/get_all_songs_usecase.dart';

part 'music_event.dart';
part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final GetAllSongsUseCase getAllSongs;
  final MusicRepository repository;
  final AudioPlayer audioPlayer;

  MusicBloc({
    required this.getAllSongs,
    required this.repository,
    required this.audioPlayer,
  }) : super(MusicState()) {
    on<LoadSongsEvent>(_onLoadSongs);
    on<PlaySongEvent>(_onPlaySong);
    on<TogglePlayPauseEvent>(_onTogglePlayPause);
    on<NextSongEvent>(_onNextSong);
    on<PreviousSongEvent>(_onPreviousSong);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<DeleteSongEvent>(_onDeleteSong);
  }

  Future<void> _onLoadSongs(LoadSongsEvent event, Emitter<MusicState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final songs = await getAllSongs();
      emit(state.copyWith(songs: songs, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onPlaySong(PlaySongEvent event, Emitter<MusicState> emit) async {
    try {
      await audioPlayer.setFilePath(event.song.path);
      await audioPlayer.play();
      emit(state.copyWith(
        currentSong: event.song,
        isPlaying: true,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onTogglePlayPause(TogglePlayPauseEvent event, Emitter<MusicState> emit) async {
    if (state.isPlaying) {
      await audioPlayer.pause();
      emit(state.copyWith(isPlaying: false));
    } else {
      await audioPlayer.play();
      emit(state.copyWith(isPlaying: true));
    }
  }

  Future<void> _onNextSong(NextSongEvent event, Emitter<MusicState> emit) async {
    if (state.currentSong == null) return;
    final currentIndex = state.songs.indexOf(state.currentSong!);
    if (currentIndex < state.songs.length - 1) {
      final nextSong = state.songs[currentIndex + 1];
      add(PlaySongEvent(nextSong));
    }
  }

  Future<void> _onPreviousSong(PreviousSongEvent event, Emitter<MusicState> emit) async {
    if (state.currentSong == null) return;
    final currentIndex = state.songs.indexOf(state.currentSong!);
    if (currentIndex > 0) {
      final previousSong = state.songs[currentIndex - 1];
      add(PlaySongEvent(previousSong));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavoriteEvent event, Emitter<MusicState> emit) async {
    await repository.toggleFavorite(event.songId);
    add(LoadSongsEvent());
  }

  Future<void> _onDeleteSong(DeleteSongEvent event, Emitter<MusicState> emit) async {
    await repository.deleteSong(event.songId);
    add(LoadSongsEvent());
  }
}
