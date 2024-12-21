import 'dart:io';
import 'package:music_player/src/model/music/music.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../screen/library/bloc/library_bloc.dart';

class LibraryMediaFunction {
  final void Function(LibraryState) emit;

  LibraryMediaFunction({required this.emit});

  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<void> loadMusicFiles() async {
    try {
      print("[INFO]: LibraryLoadingState emit qilindi.");
      emit(LibraryLoadingState());

      Permission storagePermission;
      if (Platform.isAndroid) {
        if (await Permission.manageExternalStorage.isDenied) {
          storagePermission = Permission.manageExternalStorage;
        } else {
          storagePermission = Permission.audio;
        }
      } else if (Platform.isIOS) {
        storagePermission = Permission.mediaLibrary;
      } else {
        throw UnsupportedError('Platform not supported');
      }

      var permissionStatus = await storagePermission.request();
      if (!permissionStatus.isGranted) {
        emit(LibraryNoPermissionState(message: 'Musiqa yuklab olish uchun ruxsat berilmagan'));
        return;
      }

      List<SongModel> musicFiles = await _audioQuery.querySongs(
        sortType: SongSortType.ALBUM,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );

      if (musicFiles.isNotEmpty) {
        emit(LibraryLoadedState(music: musicFiles, folders: []));
      } else {
        emit(LibraryEmptyState());
      }
    } catch (e) {
      print('[ERROR]: Musiqa fayllarini yuklashda xatolik: $e');
      emit(LibraryErrorState(message: 'Musiqa fayllarini yuklashda xatolik: $e'));
    }
  }

  Future<List<Directory>> loadMusicFolders() async {
    List<Directory> musicFolders = [];
    try {
      if (Platform.isAndroid) {
        List<String> androidMusicPaths = [
          '/storage/emulated/0/Music',
          '/storage/emulated/0/Download',
        ];

        for (var path in androidMusicPaths) {
          Directory directory = Directory(path);
          print('[INFO]: Papka tekshirilmoqda: ${directory.path}');

          if (directory.existsSync()) {
            var subDirectories = directory
                .listSync()
                .whereType<Directory>()
                .where((dir) {
              // Faqat musiqa fayllari bor papkalarni olish
              var files = dir
                  .listSync()
                  .whereType<File>()
                  .where((file) =>
              file.path.toLowerCase().endsWith('.mp3') ||
                  file.path.toLowerCase().endsWith('.wav') ||
                  file.path.toLowerCase().endsWith('.m4a'))
                  .toList();
              return files.isNotEmpty;
            }).toList();

            print('[INFO]: ${subDirectories.length} ta musiqa papkasi topildi: ${directory.path}');
            musicFolders.addAll(subDirectories);
          }
        }
      } else if (Platform.isIOS) {
        List<String> iosMusicPaths = [
          '/Users/Documents/Music',
          '/Users/Music',
          '/Users/Downloads'
        ];

        for (var path in iosMusicPaths) {
          Directory directory = Directory(path);
          if (directory.existsSync()) {
            var subDirectories = directory
                .listSync()
                .whereType<Directory>()
                .where((dir) {
              var files = dir
                  .listSync()
                  .whereType<File>()
                  .where((file) =>
              file.path.toLowerCase().endsWith('.mp3') ||
                  file.path.toLowerCase().endsWith('.wav') ||
                  file.path.toLowerCase().endsWith('.m4a'))
                  .toList();
              return files.isNotEmpty;
            }).toList();

            musicFolders.addAll(subDirectories);
          }
        }
      }

      musicFolders.sort((a, b) => a.path.compareTo(b.path));

    } catch (e) {
      print('[ERROR]: Papkalarni yuklashda xatolik: $e');
    }

    return musicFolders;
  }
}
