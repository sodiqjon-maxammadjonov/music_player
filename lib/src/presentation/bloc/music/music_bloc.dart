// music_bloc.dart
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';
import 'package:music_player/src/presentation/widgets/snackbar/snackbar.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as path;

part 'music_event.dart';
part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  MusicBloc() : super(const MusicState()) {
    on<LoadSongs>(_onLoadSongs);
    on<PlaySong>(_onPlaySong);
    on<PauseSong>(_onPauseSong);
    on<ResumeSong>(_onResumeSong);
    on<DeleteSong>(_onDeleteSong);
    on<UpdatePosition>(_onUpdatePosition);
    on<EditSong>(_onEditSong);

    // Position va duration o'zgarishlarini kuzatish
    _audioPlayer.positionStream.listen((position) {
      add(UpdatePosition(position));
    });

    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        add(PauseSong());
      }
    });
  }

  Future<void> _onLoadSongs(LoadSongs event, Emitter<MusicState> emit) async {
    try {
      emit(state.copyWith(status: MusicPlayerStatus.loading));

      final permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        final granted = await _audioQuery.permissionsRequest();
        if (!granted) {
          throw Exception('Permission denied');
        }
      }

      final songs = await _audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      // Mavjud fayllarni tekshirish
      final validSongs = songs.where((song) {
        final file = File(song.data);
        return file.existsSync();
      }).toList();

      emit(state.copyWith(
        songs: validSongs,
        status: MusicPlayerStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MusicPlayerStatus.error,
        errorMessage: 'Failed to load songs: ${e.toString()}',
      ));
    }
  }

  Future<void> _onPlaySong(PlaySong event, Emitter<MusicState> emit) async {
    try {
      final file = File(event.song.data);
      if (!await file.exists()) {
        throw Exception('Audio file not found');
      }

      if (state.currentSong?.id == event.song.id) {
        if (state.status == MusicPlayerStatus.playing) {
          add(PauseSong());
        } else {
          add(ResumeSong());
        }
        return;
      }

      emit(state.copyWith(status: MusicPlayerStatus.loading));

      await _audioPlayer.setAudioSource(
        AudioSource.file(event.song.data),
        preload: true,
      );

      await _audioPlayer.play();

      emit(state.copyWith(
        currentSong: event.song,
        status: MusicPlayerStatus.playing,
        duration: _audioPlayer.duration ?? Duration.zero,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MusicPlayerStatus.error,
        errorMessage: 'Failed to play song: ${e.toString()}',
      ));
    }
  }

  Future<void> _onPauseSong(PauseSong event, Emitter<MusicState> emit) async {
    try {
      await _audioPlayer.pause();
      emit(state.copyWith(status: MusicPlayerStatus.paused));
    } catch (e) {
      emit(state.copyWith(
        status: MusicPlayerStatus.error,
        errorMessage: 'Failed to pause: ${e.toString()}',
      ));
    }
  }

  Future<void> _onResumeSong(ResumeSong event, Emitter<MusicState> emit) async {
    try {
      await _audioPlayer.play();
      emit(state.copyWith(status: MusicPlayerStatus.playing));
    } catch (e) {
      emit(state.copyWith(
        status: MusicPlayerStatus.error,
        errorMessage: 'Failed to resume: ${e.toString()}',
      ));
    }
  }

  Future<void> _onDeleteSong(DeleteSong event, Emitter<MusicState> emit) async {
    try {
      final file = File(event.song.data);

      // Agar joriy qo'shiq o'chirilayotgan bo'lsa, pleyerni to'xtatish
      if (state.currentSong?.id == event.song.id) {
        await _audioPlayer.stop();
      }

      // UI ro'yxatini oldin yangilash
      final updatedSongs = List<SongModel>.from(state.songs)
        ..removeWhere((song) => song.id == event.song.id);

      emit(state.copyWith(
        songs: updatedSongs,
        status: state.currentSong?.id == event.song.id
            ? MusicPlayerStatus.loaded
            : state.status,
        currentSong: state.currentSong?.id == event.song.id
            ? null
            : state.currentSong,
      ));

      // Faylni o'chirish
      if (await file.exists()) {
        try {
          await file.delete();
        } catch (e) {
          // Xatolik yuz berganda ham dastur ishini davom ettirish
          print('Failed to delete file: ${e.toString()}');
        }
      }

      // MediaStore'ni yangilash uchun scan qilish
      try {
        await _audioQuery.scanMedia(file.path);
      } catch (e) {
        print('Failed to scan media: ${e.toString()}');
      }

    } catch (e) {
      emit(state.copyWith(
        status: MusicPlayerStatus.error,
        errorMessage: 'An error occurred while deleting the song. Please try again.',
      ));
    }
  }

  Future<void> _onEditSong(EditSong event, Emitter<MusicState> emit) async {
    try {
      add(LoadSongs());

    } catch (e) {
      emit(state.copyWith(
        status: MusicPlayerStatus.error,
        errorMessage: 'Failed to edit song: ${e.toString()}',
      ));
    }
  }

  void _onUpdatePosition(UpdatePosition event, Emitter<MusicState> emit) {
    emit(state.copyWith(position: event.position));
  }

  Future<void> shareSong(SongModel song) async {
    try {
      final file = File(song.data);
      if (await file.exists()) {
        await Share.shareXFiles(
          [XFile(song.data)],
          text: 'Check out this song: ${song.title}',
        );
      } else {
        throw Exception('Audio file not found');
      }
    } catch (e) {
      // Share xatosini qayta ishlash
      rethrow;
    }
  }

  Future<void> seekTo(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      emit(state.copyWith(
        status: MusicPlayerStatus.error,
        errorMessage: 'Failed to seek: ${e.toString()}',
      ));
    }
  }

  @override
  Future<void> close() async {
    await _audioPlayer.dispose();
    return super.close();
  }
}
