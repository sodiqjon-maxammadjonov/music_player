import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:share_plus/share_plus.dart';
import '../../../presentation/bloc/music/music_bloc.dart';

class MusicFunction {
  final Emitter<MusicState> emit;

  MusicFunction({required this.emit});

  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer player = AudioPlayer();

  List<SongModel> songs = [];
  SongModel? currentSong;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  bool _isDisposed = false;

  void initializeListeners() {
    player.onDurationChanged.listen((Duration d) {
      if (!_isDisposed) {
        duration = d;
        emit(MusicState(
          status: MusicPlayerStatus.playing,
          duration: duration,
          position: position,
        ));
      }
    });
    player.onPositionChanged.listen((Duration p) {
      if (!_isDisposed) {
        position = p;
        emit(MusicState(
          status: MusicPlayerStatus.playing,
          duration: duration,
          position: position,
        ));
      }
    });

    player.onPlayerComplete.listen((_) {
      if (!_isDisposed) {
        position = Duration.zero;
        emit(MusicState(
          status: MusicPlayerStatus.completed,
          duration: duration,
          position: position,
        ));
      }
    });
  }

  Future<void> loadSongs() async {
    if (_isDisposed) return;

    try {
      emit(MusicState(status: MusicPlayerStatus.loading));

      final permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        final granted = await _audioQuery.permissionsRequest();
        if (!granted) {
          throw Exception('Ruxsat berilmadi');
        }
      }

      final fetchedSongs = await _audioQuery.querySongs(
        sortType: SongSortType.DISPLAY_NAME,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      songs = fetchedSongs.where((song) {
        final file = File(song.data);
        return file.existsSync() &&
            song.data.toLowerCase().endsWith('.mp3') &&
            song.duration != null &&
            song.duration! > 0;
      }).toList();

      emit(MusicState(
        status: MusicPlayerStatus.loaded,
        songs: songs,
        successMessage: 'Qo\'shiqlar muvaffaqiyatli yuklandi',
      ));
    } catch (e) {
      log('Qo\'shiqlarni yuklashda xatolik: ${e.toString()}');
      emit(MusicState(
        status: MusicPlayerStatus.error,
        errorMessage: 'Qo\'shiqlarni yuklashda xatolik: ${e.toString()}',
      ));
    }
  }

  Future<void> playSong(SongModel song) async {
    if (_isDisposed) return;

    try {
      if (song.uri != null) {
        currentSong = song;
        await player.play(DeviceFileSource(song.uri!));
        emit(MusicState(
          status: MusicPlayerStatus.playing,
          currentSong: song,
          duration: duration,
          position: position,
        ));
      } else {
        throw Exception('Qo\'shiq URI mavjud emas');
      }
    } catch (e) {
      log('Qo\'shiqni ijro etishda xatolik: ${e.toString()}');
      emit(MusicState(
        status: MusicPlayerStatus.error,
        errorMessage: 'Qo\'shiqni ijro etishda xatolik: ${e.toString()}',
      ));
    }
  }

  Future<void> deleteSong(SongModel song) async {
    try {
      final file = File(song.data);
      if (await file.exists()) {
        await file.delete();
        songs.remove(song);
        emit(MusicState(
          status: MusicPlayerStatus.loaded,
          songs: songs,
          successMessage: 'Qo\'shiq o\'chirildi',
        ));
      } else {
        throw Exception('Fayl topilmadi');
      }
    } catch (e) {
      log('Qo\'shiqni o\'chirishda xatolik: ${e.toString()}');
      emit(MusicState(
        status: MusicPlayerStatus.error,
        errorMessage: 'Qo\'shiqni o\'chirishda xatolik: ${e.toString()}',
      ));
    }
  }

  Future<void> pauseSong() async {
    if (_isDisposed) return;

    try {
      await player.pause();
      emit(MusicState(
        status: MusicPlayerStatus.paused,
        currentSong: currentSong,
        duration: duration,
        position: position,
      ));
    } catch (e) {
      log('Qo\'shiqni to\'xtatishda xatolik: ${e.toString()}');
      emit(MusicState(
        status: MusicPlayerStatus.error,
        errorMessage: 'Qo\'shiqni to\'xtatishda xatolik: ${e.toString()}',
      ));
    }
  }

  Future<void> resumeSong() async {
    if (_isDisposed) return;

    try {
      await player.resume();
      emit(MusicState(
        status: MusicPlayerStatus.playing,
        currentSong: currentSong,
        duration: duration,
        position: position,
      ));
    } catch (e) {
      log('Qo\'shiqni davom ettirishda xatolik: ${e.toString()}');
      emit(MusicState(
        status: MusicPlayerStatus.error,
        errorMessage: 'Qo\'shiqni davom ettirishda xatolik: ${e.toString()}',
      ));
    }
  }

  Future<void> editSong(SongModel song, String newTitle) async {
    try {
      final oldFile = File(song.data);
      if (await oldFile.exists()) {
        final directory = oldFile.parent;
        final newPath = '${directory.path}/$newTitle.mp3';
        await oldFile.rename(newPath);

        await loadSongs();

        emit(MusicState(
          status: MusicPlayerStatus.loaded,
          songs: songs,
          successMessage: 'Qo\'shiq nomi o\'zgartirildi',
        ));
      } else {
        throw Exception('Fayl topilmadi');
      }
    } catch (e) {
      log('Qo\'shiq nomini o\'zgartirishda xatolik: ${e.toString()}');
      emit(MusicState(
        status: MusicPlayerStatus.error,
        errorMessage:
            'Qo\'shiq nomini o\'zgartirishda xatolik: ${e.toString()}',
      ));
    }
  }

  Future<void> seekTo(Duration position) async {
    if (_isDisposed) return;

    try {
      await player.seek(position);
      this.position = position;
      emit(MusicState(
        status: MusicPlayerStatus.playing,
        currentSong: currentSong,
        duration: duration,
        position: position,
      ));
    } catch (e) {
      log('Qo\'shiq pozitsiyasini o\'zgartirishda xatolik: ${e.toString()}');
      emit(MusicState(
        status: MusicPlayerStatus.error,
        errorMessage:
            'Qo\'shiq pozitsiyasini o\'zgartirishda xatolik: ${e.toString()}',
      ));
    }
  }

  Future<void> shareSong(SongModel song) async {
    try {
      final file = File(song.data);
      if (await file.exists()) {
        await Share.shareXFiles([XFile(song.data)], text: 'Test');
      }
    } catch (e) {
      emit(MusicState(
        status: MusicPlayerStatus.error,
        errorMessage: 'Qo\'shiqni ulashishda xatolik: ${e.toString()}',
      ));
    }
  }

  void dispose() {
    _isDisposed = true;
    player.dispose();
  }
}
