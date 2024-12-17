import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../screen/library/bloc/library_bloc.dart';

class LibraryMediaFunction {
  final void Function(LibraryState)? emit;

  LibraryMediaFunction({required this.emit});

  Future<void> fetchMusicFromStorage() async {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      emit?.call(LibraryErrorState(message: "Xotiraga kirish ruxsati yo'q"));
      return;
    }

    final OnAudioQuery audioQuery = OnAudioQuery();

    try {
      List<SongModel> songs = await audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      List<SongModel> musicFiles = songs.where((song) {
        return song.fileExtension.toLowerCase() == 'mp3' ||
            song.fileExtension.toLowerCase() == 'wav';
      }).toList();

      if (musicFiles.isEmpty) {
        emit?.call(LibraryEmptyState());
        return;
      }

      emit?.call(LibraryLoadedState(music: musicFiles));

    } catch (e) {
      emit?.call(LibraryErrorState(message: e.toString()));
    }
  }
}