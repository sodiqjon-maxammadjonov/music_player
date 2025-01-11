import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:music_player/src/data/function/music/music_function.dart';
import 'package:music_player/src/data/model/music_model.dart';

part 'music_event.dart';
part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  MusicBloc() : super(MusicEmptyState()) {
    on<MusicLoadEvent>(musicLoadEvent);
    on<MusicPlayPauseEvent>(musicPlayPauseEvent);
  }

  FutureOr<void> musicLoadEvent(
      MusicLoadEvent event,
      Emitter<MusicState> emit,
      ) async {
    await MusicFunctions(
      emit: emit,
      context: event.context,
    ).getFromStorage();
  }
  FutureOr<void> musicPlayPauseEvent(
      MusicPlayPauseEvent event,
      Emitter<MusicState> emit,
      ) async {
    await MusicFunctions(emit: emit, context: event.context)
        .playPauseSong(event.path, event.songs, event.currentIndex);
  }

}