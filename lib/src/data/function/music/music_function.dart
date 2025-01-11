import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:music_player/src/data/db_service/playlist/playlist_service.dart';
import 'package:music_player/src/presentation/bloc/music/music_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../model/music_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MusicFunctions {
  final Emitter<MusicState> emit;
  final BuildContext context;
  static final AudioPlayer _audioPlayer = AudioPlayer();
  MusicFunctions({required this.emit,required this.context});

  static final OnAudioQuery _audioQuery = OnAudioQuery();
  static final PlaylistService _db = PlaylistService();

  Future<List<Song>> getFromStorage() async {
    final l10n = AppLocalizations.of(context);
    try {
      bool hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        emit(MusicErrorState(message: l10n.noPermission));
        return [];
      }

      List<SongModel> songModels = await _audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      List<Song> songs = songModels
          .where((song) => song.fileExtension == "mp3")
          .map((songModel) => Song(
        id: songModel.id,
        title: songModel.title,
        artist: songModel.artist,
        album: songModel.album,
        duration: songModel.duration,
        path: songModel.data,
        artworkPath: null,
        createdAt: DateTime.now(),
      ))
          .toList();
      emit(MusicLoadedState(song: songs));
      return songs;
    } catch (e) {
      print('error:$e');
      emit(MusicErrorState(message: "${l10n.errorLoadSongs}: $e"));
      return [];
    }
  }

  static Future<List<Song>> getFromPlaylist(int playlistId) async {
    try {
      List<Map<String, dynamic>> playlistSongs =
          await _db.getPlaylistSongs(playlistId);

      List<Song> songs = playlistSongs
          .map((songData) => Song(
                id: songData['id'],
                title: songData['title'],
                artist: songData['artist'],
                album: songData['album'],
                duration: songData['duration'],
                path: songData['path'],
                artworkPath: songData['artwork_path'],
                createdAt: DateTime.parse(songData['created_at']),
              ))
          .toList();

      return songs;
    } catch (e) {
      throw Exception("Playlistdan qo'shiqlarni olishda xatolik: $e");
    }
  }

  static Future<bool> requestStoragePermission() async {
    PermissionStatus status = await Permission.audio.status;

    if (status.isDenied) {
      await Permission.audio.request();
      status = await Permission.audio.status;
    }

    return status.isGranted;
  }

  static String formatDuration(int? duration) {
    if (duration == null) return "0:00";
    final minutes = (duration / 60000).floor();
    final seconds = ((duration % 60000) / 1000).floor();
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> playPauseSong(String path, List<Song> songs, int currentIndex) async {
    if (_audioPlayer.state == PlayerState.playing) {
      await _audioPlayer.pause();
    } else if (_audioPlayer.state == PlayerState.paused) {
      await _audioPlayer.resume();
    } else if (_audioPlayer.state == PlayerState.completed) {
      int nextIndex = (currentIndex + 1) % songs.length;
      await _audioPlayer.play(UrlSource(songs[nextIndex].path));
    } else {
      await _audioPlayer.play(UrlSource(path));
    }
  }

  Future<List<Song>> searchSongs(String query, {int? playlistId}) async {
    List<Song> songs;

    if (playlistId != null) {
      songs = await getFromPlaylist(playlistId);
    } else {
      songs = await getFromStorage();
    }

    return songs.where((song) {
      final titleLower = song.title.toLowerCase();
      final artistLower = song.artist?.toLowerCase() ?? '';
      final albumLower = song.album?.toLowerCase() ?? '';
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) ||
          artistLower.contains(searchLower) ||
          albumLower.contains(searchLower);
    }).toList();
  }
}

extension SongExtension on Song {
  String get formattedDuration => MusicFunctions.formatDuration(duration);

  String get displayTitle => title.replaceAll(RegExp(r'\.[^/.]+$'), '');

  String get displayArtist => artist ?? 'Noma\'lum ijrochi';

  String get displayAlbum => album ?? 'Noma\'lum albom';
}
