import 'dart:io';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/song_entity.dart';
import '../../domain/repositories/music_repository.dart';

class MusicRepositoryImpl implements MusicRepository {
  final OnAudioQuery audioQuery;
  final SharedPreferences prefs;

  MusicRepositoryImpl({
    required this.audioQuery,
    required this.prefs,
  });

  @override
  Future<List<SongEntity>> getAllSongs() async {
    try {
      final songs = await audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      return songs.map((song) => _mapToEntity(song)).toList();
    } catch (e) {
      throw Exception('Failed to load songs: $e');
    }
  }

  @override
  Future<List<SongEntity>> getFavoriteSongs() async {
    try {
      final allSongs = await getAllSongs();
      return allSongs.where((song) => song.isFavorite).toList();
    } catch (e) {
      throw Exception('Failed to load favorite songs: $e');
    }
  }

  SongEntity _mapToEntity(SongModel song) {
    return SongEntity(
      id: song.id.toString(),
      title: song.title,
      artist: song.artist ?? 'Unknown Artist',
      path: song.data,
      duration: Duration(milliseconds: song.duration ?? 0),
      isFavorite: prefs.getBool('fav_${song.id}') ?? false,
    );
  }

  @override
  Future<void> toggleFavorite(String songId) async {
    try {
      final key = 'fav_$songId';
      final isFavorite = prefs.getBool(key) ?? false;
      await prefs.setBool(key, !isFavorite);
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }

  @override
  Future<void> deleteSong(String songId) async {
    try {
      final songs = await audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );

      final song = songs.firstWhere(
            (song) => song.id.toString() == songId,
        orElse: () => throw Exception('Song not found'),
      );

      final file = File(song.data);

      if (!await file.exists()) {
        throw Exception('File not found');
      }

      await file.delete();

      await prefs.remove('fav_$songId');
    } catch (e) {
      throw Exception('Failed to delete song: $e');
    }
  }

  @override
  Future<void> updateSongDetails(SongEntity song) async {
    throw UnimplementedError('Updating song details is not supported');
  }
  @override
  Future<void> addToPlaylist(String songId) async {
    try {
      // Bu yerda playlist ga qo'shish logikasini amalga oshiring
      // Masalan:
      final playlistKey = 'playlist_songs';
      final currentPlaylist = prefs.getStringList(playlistKey) ?? [];
      if (!currentPlaylist.contains(songId)) {
        currentPlaylist.add(songId);
        await prefs.setStringList(playlistKey, currentPlaylist);
      }
    } catch (e) {
      throw Exception('Failed to add song to playlist: $e');
    }
  }

  @override
  Future<void> shareSong(String path) async {
    try {
      final file = File(path);
      if (!await file.exists()) {
        throw Exception('File not found');
      }
      await Share.share(path, subject: 'Moderator Sodiqjon');
    } catch (e) {
      throw Exception('Failed to share song: $e');
    }
  }
}