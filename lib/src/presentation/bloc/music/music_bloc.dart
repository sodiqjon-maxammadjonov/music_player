import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:music_player/src/data/function/music/music_function.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'music_event.dart';
part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  MusicBloc() : super(const MusicState()) {
    on<LoadSongs>(onLoadSongs);
    on<PlaySong>(onPlaySong);
    on<PauseSong>(onPauseSong);
    on<ResumeSong>(onResumeSong);
    on<DeleteSong>(onDeleteSong);
    on<UpdatePosition>(onUpdatePosition);
    on<EditSong>(onEditSong);
    on<SeekTo>(onSeekTo);
    on<ShareSong>(onShareSong);
  }

  FutureOr<void> onLoadSongs(
      LoadSongs event,
      Emitter<MusicState> emit,
      ) async {
    try {
      emit(state.copyWith(status: MusicPlayerStatus.loading));
      await MusicFunction(emit: emit).loadSongs();
      emit(state.copyWith(status: MusicPlayerStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
        status: MusicPlayerStatus.error,
        errorMessage: 'Failed to load songs: $e',
      ));
    }
  }

  FutureOr<void> onPlaySong(
      PlaySong event,
      Emitter<MusicState> emit,
      ) async {
    try {
      emit(state.copyWith(status: MusicPlayerStatus.loading));
      await MusicFunction(emit: emit).playSong(event.song);
      emit(state.copyWith(status: MusicPlayerStatus.playing, currentSong: event.song));
    } catch (e) {
      emit(state.copyWith(
        status: MusicPlayerStatus.error,
        errorMessage: 'Failed to play song: $e',
      ));
    }
  }

  FutureOr<void> onPauseSong(
      PauseSong event,
      Emitter<MusicState> emit,
      ) async {
    await MusicFunction(emit: emit).pauseSong();
    emit(state.copyWith(status: MusicPlayerStatus.paused));
  }

  FutureOr<void> onResumeSong(
      ResumeSong event,
      Emitter<MusicState> emit,
      ) async {
    await MusicFunction(emit: emit).resumeSong();
    emit(state.copyWith(status: MusicPlayerStatus.playing));
  }

  FutureOr<void> onDeleteSong(
      DeleteSong event,
      Emitter<MusicState> emit,
      ) async {
    try {
      await MusicFunction(emit: emit).deleteSong(event.song);
      emit(state.copyWith(status: MusicPlayerStatus.loaded));  // Song deleted, update the state
    } catch (e) {
      emit(state.copyWith(
        status: MusicPlayerStatus.error,
        errorMessage: 'Failed to delete song: $e',
      ));
    }
  }

  FutureOr<void> onUpdatePosition(
      UpdatePosition event,
      Emitter<MusicState> emit,
      ) async {
    emit(state.copyWith(
      position: event.position,
      duration: event.duration,
    ));
  }

  FutureOr<void> onEditSong(
      EditSong event,
      Emitter<MusicState> emit,
      ) async {
    try {
      await MusicFunction(emit: emit).editSong(event.song, event.newTitle);
      emit(state.copyWith(status: MusicPlayerStatus.loaded));  // Update song after editing
    } catch (e) {
      emit(state.copyWith(
        status: MusicPlayerStatus.error,
        errorMessage: 'Failed to edit song: $e',
      ));
    }
  }

  FutureOr<void> onSeekTo(
      SeekTo event,
      Emitter<MusicState> emit,
      ) async {
    await MusicFunction(emit: emit).seekTo(event.position);
    emit(state.copyWith(position: event.position));
  }

  FutureOr<void> onShareSong(
      ShareSong event,
      Emitter<MusicState> emit,
      ) async {
    try {
      await MusicFunction(emit: emit).shareSong(event.song);
    } catch (e) {
      emit(state.copyWith(
        status: MusicPlayerStatus.error,
        errorMessage: 'Failed to share song: $e',
      ));
    }
  }
}