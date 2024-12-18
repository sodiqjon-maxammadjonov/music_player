import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import '../../screen/library/bloc/library_bloc.dart';

class LibraryMediaFunction {
  final void Function(LibraryState) emit;

  LibraryMediaFunction({required this.emit});

  Future<void> loadMusicFiles() async {
    try {
      print("[INFO]: LibraryLoadingState emit qilindi.");
      emit(LibraryLoadingState());
      print("[INFO]: LibraryLoadingState successfully emitted.");

      Permission storagePermission;

      // Platformni aniqlash va ruxsatni tekshirish
      if (Platform.isAndroid) {
        if (await Permission.manageExternalStorage.isGranted) {
          storagePermission = Permission.manageExternalStorage;
        } else {
          storagePermission = Permission.audio;
        }
      } else if (Platform.isIOS) {
        storagePermission = Permission.mediaLibrary;
      } else {
        throw UnsupportedError('Platform not supported');
      }

      print("[INFO]: Ruxsat turi: ${Platform.isAndroid ? 'Android - ${storagePermission.toString()}' : 'iOS - ${storagePermission.toString()}'}");

      var permissionStatus = await storagePermission.request();
      print('[INFO]: Ruxsat so\'raldi. Javob: $permissionStatus');

      if (!permissionStatus.isGranted) {
        print('[ERROR]: Ruxsat berilmadi! Musiqa yuklash jarayoni to\'xtatildi.');
        emit(LibraryNoPermissionState(message: 'Musiqa yuklab olish uchun ruxsat berilmagan'));
        print("[INFO]: LibraryNoPermissionState successfully emitted.");
        return;
      }

      List<File> musicFiles = [];

      if (Platform.isAndroid) {
        print("[INFO]: Android musiqa kataloglari skanerlash jarayoni boshlandi.");
        List<String> androidMusicPaths = [
          '/storage/emulated/0/Music',
          '/storage/emulated/0/Download',
        ];

        for (var path in androidMusicPaths) {
          Directory musicDir = Directory(path);
          print('[INFO]: Katalog: ${musicDir.path} tekshirilmoqda.');

          if (musicDir.existsSync()) {
            print('[INFO]: Katalog mavjud. Fayllar skanerlash jarayoni boshlandi.');
            var foundFiles = musicDir
                .listSync(recursive: true)
                .whereType<File>()
                .where((file) =>
            file.path.toLowerCase().endsWith('.mp3') ||
                file.path.toLowerCase().endsWith('.wav') ||
                file.path.toLowerCase().endsWith('.m4a'))
                .toList();

            print('[INFO]: ${foundFiles.length} ta fayl topildi katalogdan: ${musicDir.path}');
            musicFiles.addAll(foundFiles);
          } else {
            print('[WARNING]: Katalog mavjud emas: ${musicDir.path}');
          }
        }

        print('[INFO]: Android musiqa fayllari topildi: ${musicFiles.length}');
      } else if (Platform.isIOS) {
        print("[INFO]: iOS musiqa kataloglari skanerlash jarayoni boshlandi.");
        List<String> iosMusicPaths = [
          '/Users/Documents/Music',
          '/Users/Music',
          '/Users/Downloads'
        ];

        for (var path in iosMusicPaths) {
          Directory musicDir = Directory(path);
          print('[INFO]: Katalog: ${musicDir.path} tekshirilmoqda.');

          if (musicDir.existsSync()) {
            print('[INFO]: Katalog mavjud. Fayllar skanerlash jarayoni boshlandi.');
            var foundFiles = musicDir
                .listSync(recursive: true)
                .whereType<File>()
                .where((file) =>
            file.path.toLowerCase().endsWith('.mp3') ||
                file.path.toLowerCase().endsWith('.wav') ||
                file.path.toLowerCase().endsWith('.m4a'))
                .toList();

            print('[INFO]: ${foundFiles.length} ta fayl topildi katalogdan: ${musicDir.path}');
            musicFiles.addAll(foundFiles);
          } else {
            print('[WARNING]: Katalog mavjud emas: ${musicDir.path}');
          }
        }

        print('[INFO]: iOS musiqa fayllari topildi: ${musicFiles.length}');
      }

      musicFiles.sort((a, b) => a.path.compareTo(b.path));

      if (musicFiles.isNotEmpty) {
        await Future.delayed(const Duration(seconds: 2));
        print('[INFO]: ${musicFiles.length} ta musiqa fayli topildi va yuklandi.');
        emit(LibraryLoadedState(music: musicFiles));
        print("[INFO]: LibraryLoadedState successfully emitted.");
      } else {
        print('[INFO]: Hech qanday musiqa fayllari topilmadi.');
        emit(LibraryEmptyState());
        print("[INFO]: LibraryEmptyState successfully emitted.");
      }
    } catch (e) {
      print('[ERROR]: Musiqa fayllarini yuklab olishda xatolik: $e');
      emit(LibraryErrorState(message: 'Musiqa fayllarini yuklab olishda xatolik: $e'));
      print("[INFO]: LibraryErrorState successfully emitted.");
    }
  }
}
