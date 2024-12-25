import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/song.dart';
import '../../domain/repositories/audio_repository.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final AudioRepository repository;
  List<Song> songs = [];
  int currentIndex = 0;

  AudioPlayerBloc({required this.repository}) : super(AudioPlayerInitial()) {
    on<LoadSongs>((event, emit) async {
      emit(AudioPlayerLoading());
      try {
        songs = await repository.getSongs();
        emit(AudioPlayerLoaded(
          songs: songs,
          isPlaying: false,
        ));
      } catch (e) {
        emit(AudioPlayerError(e.toString()));
      }
    });

    on<PlaySong>((event, emit) async {
      try {
        await repository.playSong(event.song);
        currentIndex = songs.indexOf(event.song);
        emit(AudioPlayerLoaded(
          songs: songs,
          currentSong: event.song,
          isPlaying: true,
        ));
      } catch (e) {
        emit(AudioPlayerError(e.toString()));
      }
    });

    on<PauseSong>((event, emit) async {
      try {
        await repository.pauseSong();
        emit(AudioPlayerLoaded(
          songs: songs,
          currentSong: songs[currentIndex],
          isPlaying: false,
        ));
      } catch (e) {
        emit(AudioPlayerError(e.toString()));
      }
    });

    on<NextSong>((event, emit) async {
      try {
        if (currentIndex < songs.length - 1) {
          currentIndex++;
          await repository.playSong(songs[currentIndex]);
          emit(AudioPlayerLoaded(
            songs: songs,
            currentSong: songs[currentIndex],
            isPlaying: true,
          ));
        }
      } catch (e) {
        emit(AudioPlayerError(e.toString()));
      }
    });

    on<PreviousSong>((event, emit) async {
      try {
        if (currentIndex > 0) {
          currentIndex--;
          await repository.playSong(songs[currentIndex]);
          emit(AudioPlayerLoaded(
            songs: songs,
            currentSong: songs[currentIndex],
            isPlaying: true,
          ));
        }
      } catch (e) {
        emit(AudioPlayerError(e.toString()));
      }
    });
  }
}