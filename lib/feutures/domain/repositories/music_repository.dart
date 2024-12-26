import '../entities/song_entity.dart';

abstract class MusicRepository {
  Future<List<SongEntity>> getAllSongs();
  Future<void> toggleFavorite(String songId);
  Future<void> deleteSong(String songId);
  Future<void> updateSongDetails(SongEntity song);
  Future<List<SongEntity>> getFavoriteSongs();
  Future<void> addToPlaylist(String songId);
  Future<void> shareSong(String path);
}