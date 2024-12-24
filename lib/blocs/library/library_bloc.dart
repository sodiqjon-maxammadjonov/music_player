import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/song.dart';
import '../../services/database_service.dart';
import '../../services/storage_service.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final DatabaseService _databaseService;
  final StorageService _storageService;

  LibraryBloc(this._databaseService, this._storageService) : super(LibraryInitial()) {
    on<LoadLibrary>(_onLoadLibrary);
    on<ImportSongs>(_onImportSongs);
    on<RefreshLibrary>(_onRefreshLibrary);
    on<DeleteSong>(_onDeleteSong);
  }

  Future<void> _onLoadLibrary(LoadLibrary event, Emitter<LibraryState> emit) async {
    try {
      emit(LibraryLoading());
      final songs = await _databaseService.getAllSongs();
      final grouped = _groupSongs(songs);
      emit(LibraryLoaded(songs, grouped.albumSongs, grouped.artistSongs));
    } catch (e) {
      emit(LibraryError('Failed to load library: $e'));
    }
  }

  Future<void> _onImportSongs(ImportSongs event, Emitter<LibraryState> emit) async {
    try {
      emit(LibraryLoading());

      // Pick music files
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );

      if (result != null) {
        for (var file in result.files) {
          if (file.path != null) {
            final metadata = await MetadataRetriever.fromFile(File(file.path!));

            // Create song object
            final song = Song(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: metadata.trackName ?? file.name,
              artist: metadata.authorName ?? 'Unknown Artist',
              album: metadata.albumName,
              path: file.path!,
              duration: Duration(milliseconds: metadata.trackDuration ?? 0),
              artwork: metadata.albumArt != null
                  ? await _storageService.saveArtwork(metadata.albumArt!, metadata.albumName ?? 'unknown')
                  : null,
              dateAdded: DateTime.now(),
            );

            // Save to database
            await _databaseService.insertSong(song);
          }
        }

        // Reload library
        add(LoadLibrary());
      }
    } catch (e) {
      emit(LibraryError('Failed to import songs: $e'));
    }
  }

  Future<void> _onRefreshLibrary(RefreshLibrary event, Emitter<LibraryState> emit) async {
    try {
      emit(LibraryLoading());
      // Verify all songs still exist
      final songs = await _databaseService.getAllSongs();
      for (var song in songs) {
        if (!await _storageService.fileExists(song.path)) {
          await _databaseService.deleteSong(song.id);
        }
      }
      add(LoadLibrary());
    } catch (e) {
      emit(LibraryError('Failed to refresh library: $e'));
    }
  }

  Future<void> _onDeleteSong(DeleteSong event, Emitter<LibraryState> emit) async {
    try {
      await _databaseService.deleteSong(event.song.id);
      if (event.song.artwork != null) {
        await _storageService.deleteFile(event.song.artwork!);
      }
      add(LoadLibrary());
    } catch (e) {
      emit(LibraryError('Failed to delete song: $e'));
    }
  }
  _GroupedSongs _groupSongs(List<Song> songs) {
    final albumSongs = <String, List<Song>>{};
    final artistSongs = <String, List<Song>>{};

    for (var song in songs) {
      if (song.album != null) {
        albumSongs.putIfAbsent(song.album!, () => []).add(song);
      }
      artistSongs.putIfAbsent(song.artist, () => []).add(song);
    }

    return _GroupedSongs(albumSongs, artistSongs);
  }
}

class _GroupedSongs {
  final Map<String, List<Song>> albumSongs;
  final Map<String, List<Song>> artistSongs;

  _GroupedSongs(this.albumSongs, this.artistSongs);
}
