import 'dart:io';
import 'package:music_player/src/util/constants/const_value.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../screen/library/bloc/library_bloc.dart';

class LibraryMediaFunction {
  final void Function(LibraryState)? emit;

  LibraryMediaFunction({required this.emit});

  Future<void> fetchMusicFromStorage() async {
    print("Ruxsat so'ralmoqda...");
    var status = await Permission.storage.request();
    print("Ruxsat holati: $status");

    if (!status.isGranted) {
      print("Xatolik: Ruxsat berilmagan!");
      emit?.call(LibraryNoPermissionState(
        message: ConstValue.noPermission,
      ));
      return;
    }

    try {
      List<File> musicFiles = [];
      Directory directory = Directory("/storage/emulated/0/");
      print("Root katalog: ${directory.path}");

      await _scanDirectory(directory, musicFiles);

      print("Topilgan fayllar soni: ${musicFiles.length}");

      if (musicFiles.isEmpty) {
        print("Natija: Hech qanday musiqa topilmadi.");
        emit?.call(LibraryEmptyState());
      } else {
        print("Natija: Musiqa fayllari yuklandi!");
        emit?.call(LibraryLoadedState(music: musicFiles));
      }
    } catch (e) {
      print("Xatolik: ${e.toString()}");
      emit?.call(LibraryErrorState(message: e.toString()));
    }
  }

  Future<void> _scanDirectory(Directory directory, List<File> musicFiles) async {
    try {
      print("Katalog tekshirilmoqda: ${directory.path}");
      await for (var entity in directory.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          String extension = entity.path.split('.').last.toLowerCase();
          print("Topilgan fayl: ${entity.path} (Extension: $extension)");
          if (extension == 'mp3' || extension == 'wav' || extension == 'm4a' || extension == 'flac') {
            print("Qo'shildi: ${entity.path}");
            musicFiles.add(entity);
          }
        }
      }
    } catch (e) {
      print("Katalog o'qishda xatolik: ${directory.path} => ${e.toString()}");
    }
  }
}
