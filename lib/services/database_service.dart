import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/playlist.dart';
import '../models/song.dart';

class DatabaseService {
  late Database _db;

  static Future<DatabaseService> init() async {
    final service = DatabaseService();
    await service.initialize();
    return service;
  }

  Future<void> initialize() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'music_player.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE songs (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            artist TEXT NOT NULL,
            album TEXT,
            path TEXT NOT NULL,
            duration INTEGER NOT NULL,
            artwork TEXT,
            dateAdded TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE playlists (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT,
            songIds TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE favorites (
            songId TEXT PRIMARY KEY,
            addedAt TEXT NOT NULL,
            FOREIGN KEY (songId) REFERENCES songs (id)
              ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  Future<List<Song>> getAllSongs() async {
    final maps = await _db.query('songs', orderBy: 'dateAdded DESC');
    return maps.map((map) => Song.fromMap(map)).toList();
  }

  Future<void> insertSong(Song song) async {
    await _db.insert('songs', song.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Playlist>> getAllPlaylists() async {
    final maps = await _db.query('playlists', orderBy: 'updatedAt DESC');
    return maps.map((map) => Playlist.fromMap(map)).toList();
  }

  Future<Playlist?> getPlaylist(String playlistId) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'playlists',
      where: 'id = ?',
      whereArgs: [playlistId],
    );

    if (maps.isNotEmpty) {
      return Playlist.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> deletePlaylist(String playlistId) async {
    await _db.delete('playlists', where: 'id = ?', whereArgs: [playlistId]);
  }

  Future<void> insertPlaylist(Playlist playlist) async {
    await _db.insert('playlists', playlist.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<String>> getFavoriteSongIds() async {
    final maps = await _db.query('favorites', orderBy: 'addedAt DESC');
    return maps.map((map) => map['songId'] as String).toList();
  }

  Future<void> addToFavorites(String songId) async {
    await _db.insert('favorites',
        {'songId': songId, 'addedAt': DateTime.now().toIso8601String()});
  }

  Future<void> removeFromFavorites(String songId) async {
    await _db.delete('favorites', where: 'songId = ?', whereArgs: [songId]);
  }

  Future<void> deleteSong(String songId) async {
    await _db.delete(
      'songs',
      where: 'id = ?',
      whereArgs: [songId],
    );
  }
}
