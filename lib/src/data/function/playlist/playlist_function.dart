import 'package:music_player/src/data/model/music_model.dart';

import '../../db_service/playlist/playlist_service.dart';
import '../../model/playlist_model.dart';

class PlaylistFunction {

  static final PlaylistService _db = PlaylistService();

  static Future<int> createPlaylist(String name, {String? description}) async {
    try {
      return await _db.createPlaylist({
        'name': name,
        'description': description,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception("Playlist yaratishda xatolik: $e");
    }
  }

  static Future<void> addToPlaylist(int playlistId, Song song) async {
    try {
      final songMap = song.toMap();
      final songId = await _db.addSong(songMap);

      final playlistSongs = await _db.getPlaylistSongs(playlistId);
      final position = playlistSongs.length;

      await _db.addSongToPlaylist(playlistId, songId, position);
    } catch (e) {
      throw Exception("Qo'shiqni playlistga qo'shishda xatolik: $e");
    }
  }

  static Future<void> removeFromPlaylist(int playlistId, int songId) async {
    try {
      await _db.removeSongFromPlaylist(playlistId, songId);
    } catch (e) {
      throw Exception("Qo'shiqni playlistdan o'chirishda xatolik: $e");
    }
  }

  static Future<List<Playlist>> getAllPlaylists() async {
    try {
      final playlistMaps = await _db.getPlaylists();
      return playlistMaps.map((map) => Playlist.fromMap(map)).toList();
    } catch (e) {
      throw Exception("Playlistlarni olishda xatolik: $e");
    }
  }

  static Future<void> deletePlaylist(int playlistId) async {
    try {
      await _db.deletePlaylist(playlistId);
    } catch (e) {
      throw Exception("Playlistni o'chirishda xatolik: $e");
    }
  }

  static Future<void> updatePlaylist(int playlistId, String name,
      {String? description}) async {
    try {
      await _db.updatePlaylist(playlistId, {
        'name': name,
        'description': description,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception("Playlistni yangilashda xatolik: $e");
    }
  }
}