import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:music_player/src/functions/library/library_media_function.dart';
import 'package:on_audio_query/on_audio_query.dart';
part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc() : super(LibraryInitial()) {
    on<LibraryLoadEvent>(libraryLoadEvent);
  }

  FutureOr<void> libraryLoadEvent(
      LibraryLoadEvent event, Emitter<LibraryState> emit) async {
    await LibraryMediaFunction(emit: emit.call).loadMusicFiles();
  }
}
