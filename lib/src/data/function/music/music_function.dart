import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:share_plus/share_plus.dart';
import '../../../presentation/bloc/music/music_bloc.dart';
import 'package:path/path.dart' as path;

class MusicFunction {
  final Emitter<MusicState> emit;
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<SongModel> songs = [];
  SongModel? currentSong;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  bool _isDisposed = false;

  MusicFunction({required this.emit}) {
    _initializeListeners();
  }

  void _initializeListeners() {
    _audioPlayer.positionStream.listen((newPosition) async {
      position = newPosition;
      if (!_isDisposed) {
        _emitCurrentState(
          status: _audioPlayer.playing
              ? MusicPlayerStatus.playing
              : MusicPlayerStatus.paused,
        );
      }
    });

    _audioPlayer.durationStream.listen((newDuration) {
      duration = newDuration ?? Duration.zero;
      if (!_isDisposed) {
        _emitCurrentState();
      }
    });

    _audioPlayer.playerStateStream.listen((playerState) async {
      if (playerState.processingState == ProcessingState.completed && !_isDisposed) {
        await pauseSong();
        await seekTo(Duration.zero);
      }
    });
  }

  void _emitCurrentState({
    MusicPlayerStatus? status,
    String? successMessage,
    String? errorMessage,
  }) {
    if (!_isDisposed) {
      emit(MusicState(
        songs: songs,
        status: status ?? (currentSong == null
            ? MusicPlayerStatus.loaded
            : (_audioPlayer.playing ? MusicPlayerStatus.playing : MusicPlayerStatus.paused)),
        currentSong: currentSong,
        position: position,
        duration: duration,
        successMessage: successMessage,
        errorMessage: errorMessage,
      ));
    }
  }

  Future<void> loadSongs() async {
    if (_isDisposed) return;

    try {
      _emitCurrentState(status: MusicPlayerStatus.loading);

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

      _emitCurrentState(
        status: MusicPlayerStatus.loaded,
        successMessage: 'Qo\'shiqlar muvaffaqiyatli yuklandi',
      );
    } catch (e) {
      log('Qo\'shiqlarni yuklashda xatolik: ${e.toString()}');
      _emitCurrentState(
        status: MusicPlayerStatus.error,
        errorMessage: 'Qo\'shiqlarni yuklashda xatolik: ${e.toString()}',
      );
    }
  }

  Future<void> playSong(SongModel song) async {
    if (_isDisposed) return;

    try {
      _emitCurrentState(status: MusicPlayerStatus.loading);

      final file = File(song.data);
      if (!await file.exists()) {
        throw Exception('Audio fayl topilmadi');
      }

      if (currentSong?.id == song.id && _audioPlayer.playing) {
        await pauseSong();
        return;
      }

      // Agar boshqa qo'shiq ijro etilayotgan bo'lsa, avval to'xtatamiz
      if (_audioPlayer.playing) {
        await _audioPlayer.stop();
      }

      await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(song.data)),
        preload: true,
      );

      currentSong = song;
      await _audioPlayer.play();

      _emitCurrentState(
        status: MusicPlayerStatus.playing,
        successMessage: 'Ijro etilmoqda: ${song.title}',
      );
    } catch (e) {
      log('Qo\'shiqni ijro etishda xatolik: ${e.toString()}');
      _emitCurrentState(
        status: MusicPlayerStatus.error,
        errorMessage: 'Qo\'shiqni ijro etishda xatolik: ${e.toString()}',
      );
    }
  }

  Future<void> pauseSong() async {
    if (_isDisposed) return;

    try {
      await _audioPlayer.pause();
      _emitCurrentState(status: MusicPlayerStatus.paused);
    } catch (e) {
      log('Qo\'shiqni to\'xtatishda xatolik: ${e.toString()}');
      _emitCurrentState(
        status: MusicPlayerStatus.error,
        errorMessage: 'Qo\'shiqni to\'xtatishda xatolik: ${e.toString()}',
      );
    }
  }

  Future<void> resumeSong() async {
    if (_isDisposed) return;

    try {
      if (currentSong == null) {
        throw Exception('Hozirda hech qanday qo\'shiq tanlanmagan');
      }
      await _audioPlayer.play();
      _emitCurrentState(status: MusicPlayerStatus.playing);
    } catch (e) {
      log('Qo\'shiqni davom ettirishda xatolik: ${e.toString()}');
      _emitCurrentState(
        status: MusicPlayerStatus.error,
        errorMessage: 'Qo\'shiqni davom ettirishda xatolik: ${e.toString()}',
      );
    }
  }

  Future<void> deleteSong(SongModel song) async {
    if (_isDisposed) return;

    try {
      _emitCurrentState(status: MusicPlayerStatus.loading);

      final file = File(song.data);
      if (currentSong?.id == song.id) {
        await _audioPlayer.stop();
        currentSong = null;
      }

      if (await file.exists()) {
        await file.delete();
        songs.removeWhere((s) => s.id == song.id);
        await _audioQuery.scanMedia(file.path);
      }

      _emitCurrentState(
        status: MusicPlayerStatus.loaded,
        successMessage: 'Qo\'shiq muvaffaqiyatli o\'chirildi',
      );
    } catch (e) {
      log('Qo\'shiqni o\'chirishda xatolik: ${e.toString()}');
      _emitCurrentState(
        status: MusicPlayerStatus.error,
        errorMessage: 'Qo\'shiqni o\'chirishda xatolik: ${e.toString()}',
      );
    }
  }

  Future<void> shareSong(SongModel song) async {
    if (_isDisposed) return;

    try {
      final file = File(song.data);
      if (!await file.exists()) {
        throw Exception('Audio fayl topilmadi');
      }

      await Share.shareXFiles(
        [XFile(song.data)],
        text: 'Bu qo\'shiqni tinglang: ${song.title}',
      );

      _emitCurrentState(
        successMessage: 'Qo\'shiq muvaffaqiyatli ulashildi',
      );
    } catch (e) {
      log('Qo\'shiqni ulashishda xatolik: ${e.toString()}');
      _emitCurrentState(
        status: MusicPlayerStatus.error,
        errorMessage: 'Qo\'shiqni ulashishda xatolik: ${e.toString()}',
      );
    }
  }

  Future<void> seekTo(Duration newPosition) async {
    if (_isDisposed) return;

    try {
      await _audioPlayer.seek(newPosition);
      position = newPosition;
      _emitCurrentState();
    } catch (e) {
      log('Pozitsiyani o\'zgartirishda xatolik: ${e.toString()}');
      _emitCurrentState(
        status: MusicPlayerStatus.error,
        errorMessage: 'Pozitsiyani o\'zgartirishda xatolik: ${e.toString()}',
      );
    }
  }

  Future<void> editSong(SongModel song, String newTitle) async {
    if (_isDisposed) return;

    try {
      _emitCurrentState(status: MusicPlayerStatus.loading);

      final file = File(song.data);
      if (!await file.exists()) {
        throw Exception('Audio fayl topilmadi');
      }

      // Yangi nom yaroqli ekanligini tekshirish
      if (newTitle.trim().isEmpty) {
        throw Exception('Yangi nom bo\'sh bo\'lishi mumkin emas');
      }

      final directory = file.parent;
      final extension = path.extension(file.path);
      final newPath = path.join(directory.path, '$newTitle$extension');

      // Agar yangi nom bilan fayl mavjud bo'lsa
      if (await File(newPath).exists()) {
        throw Exception('Bu nom bilan fayl allaqachon mavjud');
      }

      // Agar hozirgi qo'shiq ijro etilayotgan bo'lsa, to'xtatamiz
      if (currentSong?.id == song.id && _audioPlayer.playing) {
        await pauseSong();
      }

      await file.rename(newPath);
      await _audioQuery.scanMedia(newPath);

      // Qo'shiqlar ro'yxatini yangilash
      await loadSongs();

      _emitCurrentState(
        status: MusicPlayerStatus.loaded,
        successMessage: 'Qo\'shiq nomi muvaffaqiyatli o\'zgartirildi',
      );
    } catch (e) {
      log('Qo\'shiq nomini o\'zgartirishda xatolik: ${e.toString()}');
      _emitCurrentState(
        status: MusicPlayerStatus.error,
        errorMessage: 'Qo\'shiq nomini o\'zgartirishda xatolik: ${e.toString()}',
      );
    }
  }

  Future<void> dispose() async {
    _isDisposed = true;
    await _audioPlayer.dispose();
  }
}