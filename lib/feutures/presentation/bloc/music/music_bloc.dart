import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';
import 'dart:async';
import 'dart:math';

import '../../../../core/widgets/repeat_mode.dart';
import '../../../domain/entities/song_entity.dart';
import '../../../domain/repositories/music_repository.dart';
import '../../../domain/usecases/get_all_songs_usecase.dart';

part 'music_event.dart';
part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final GetAllSongsUseCase getAllSongs;
  final MusicRepository repository;
  final AudioPlayer audioPlayer;
  StreamSubscription<Duration?>? _positionSubscription;
  List<SongEntity> _shuffledSongs = [];
  Random _random = Random();

  MusicBloc({
    required this.getAllSongs,
    required this.repository,
    required this.audioPlayer,
  }) : super(const MusicState()) {
    on<LoadSongsEvent>(_onLoadSongs);
    on<PlaySongEvent>(_onPlaySong);
    on<TogglePlayPauseEvent>(_onTogglePlayPause);
    on<NextSongEvent>(_onNextSong);
    on<PreviousSongEvent>(_onPreviousSong);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<DeleteSongEvent>(_onDeleteSong);
    on<SeekToEvent>(_onSeekTo);
    on<UpdateProgressEvent>(_onUpdateProgress);
    on<ToggleShuffleEvent>(_onToggleShuffle);
    on<ToggleRepeatEvent>(_onToggleRepeat);
    on<SetVolumeEvent>(_onSetVolume);
    on<AddToPlaylistEvent>(_onAddToPlaylist);
    on<ShareSongEvent>(_onShareSong);

    _initializeAudioPlayer();
  }

  void _initializeAudioPlayer() {
    _positionSubscription = audioPlayer.positionStream.listen((position) {
      if (position != null) {
        add(UpdateProgressEvent(position));
      }
    });

    audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _onSongComplete();
      }
    });
  }

  void _onSongComplete() {
    switch (state.repeatMode) {
      case RepeatMode.off:
        add(NextSongEvent());
        break;
      case RepeatMode.all:
        add(NextSongEvent());
        break;
      case RepeatMode.one:
        add(PlaySongEvent(state.currentSong!));
        break;
    }
  }

  Future<void> _onLoadSongs(LoadSongsEvent event, Emitter<MusicState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final songs = await getAllSongs();
      emit(state.copyWith(songs: songs, isLoading: false));
      _shuffledSongs = List.from(songs);
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
        currentPosition: Duration.zero,
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

    final songs = state.isShuffleEnabled ? _shuffledSongs : state.songs;
    final currentIndex = songs.indexOf(state.currentSong!);

    if (currentIndex < songs.length - 1) {
      add(PlaySongEvent(songs[currentIndex + 1]));
    } else if (state.repeatMode == RepeatMode.all) {
      add(PlaySongEvent(songs[0]));
    }
  }

  Future<void> _onPreviousSong(PreviousSongEvent event, Emitter<MusicState> emit) async {
    if (state.currentSong == null) return;

    final songs = state.isShuffleEnabled ? _shuffledSongs : state.songs;
    final currentIndex = songs.indexOf(state.currentSong!);

    if (currentIndex > 0) {
      add(PlaySongEvent(songs[currentIndex - 1]));
    } else if (state.repeatMode == RepeatMode.all) {
      add(PlaySongEvent(songs[songs.length - 1]));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavoriteEvent event, Emitter<MusicState> emit) async {
    try {
      await repository.toggleFavorite(event.songId);
      add(LoadSongsEvent());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDeleteSong(DeleteSongEvent event, Emitter<MusicState> emit) async {
    try {
      await repository.deleteSong(event.songId);
      if (state.currentSong?.id == event.songId) {
        await audioPlayer.stop();
        emit(state.copyWith(currentSong: null, isPlaying: false));
      }
      add(LoadSongsEvent());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onSeekTo(SeekToEvent event, Emitter<MusicState> emit) async {
    try {
      await audioPlayer.seek(event.position);
      emit(state.copyWith(currentPosition: event.position));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onUpdateProgress(UpdateProgressEvent event, Emitter<MusicState> emit) {
    emit(state.copyWith(currentPosition: event.position));
  }

  void _onToggleShuffle(ToggleShuffleEvent event, Emitter<MusicState> emit) {
    if (!state.isShuffleEnabled) {
      _shuffledSongs = List.from(state.songs)..shuffle(_random);
    }
    emit(state.copyWith(isShuffleEnabled: !state.isShuffleEnabled));
  }

  void _onToggleRepeat(ToggleRepeatEvent event, Emitter<MusicState> emit) {
    final nextMode = switch (state.repeatMode) {
      RepeatMode.off => RepeatMode.all,
      RepeatMode.all => RepeatMode.one,
      RepeatMode.one => RepeatMode.off,
    };
    emit(state.copyWith(repeatMode: nextMode));
  }

  Future<void> _onSetVolume(SetVolumeEvent event, Emitter<MusicState> emit) async {
    try {
      await audioPlayer.setVolume(event.volume);
      emit(state.copyWith(volume: event.volume));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onAddToPlaylist(AddToPlaylistEvent event, Emitter<MusicState> emit) async {
    try {
      await repository.addToPlaylist(event.songId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onShareSong(ShareSongEvent event, Emitter<MusicState> emit) async {
    try {
      await repository.shareSong(event.path);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    audioPlayer.dispose();
    return super.close();
  }
}