import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PlaylistService {
  static final PlaylistService _instance = PlaylistService._internal();
  static Database? _database;

  factory PlaylistService() => _instance;

  PlaylistService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'music_player.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE playlists(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    await db.execute('''
      CREATE TABLE songs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        artist TEXT,
        album TEXT,
        duration INTEGER,
        path TEXT NOT NULL,
        artwork_path TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Playlist qo'shiqlari jadvali (ko'p-ko'p bog'lanish)
    await db.execute('''
      CREATE TABLE playlist_songs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        playlist_id INTEGER,
        song_id INTEGER,
        position INTEGER,
        added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (playlist_id) REFERENCES playlists (id) ON DELETE CASCADE,
        FOREIGN KEY (song_id) REFERENCES songs (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> createPlaylist(Map<String, dynamic> playlist) async {
    final Database db = await database;
    return await db.insert('playlists', playlist);
  }

  Future<List<Map<String, dynamic>>> getPlaylists() async {
    final Database db = await database;
    return await db.query('playlists', orderBy: 'created_at DESC');
  }

  Future<Map<String, dynamic>?> getPlaylist(int id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'playlists',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updatePlaylist(int id, Map<String, dynamic> playlist) async {
    final Database db = await database;
    return await db.update(
      'playlists',
      playlist,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletePlaylist(int id) async {
    final Database db = await database;
    return await db.delete(
      'playlists',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> addSong(Map<String, dynamic> song) async {
    final Database db = await database;
    return await db.insert('songs', song);
  }

  Future<List<Map<String, dynamic>>> getSongs() async {
    final Database db = await database;
    return await db.query('songs', orderBy: 'title ASC');
  }

  Future<Map<String, dynamic>?> getSong(int id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'songs',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> addSongToPlaylist(int playlistId, int songId, int position) async {
    final Database db = await database;
    return await db.insert('playlist_songs', {
      'playlist_id': playlistId,
      'song_id': songId,
      'position': position,
    });
  }

  Future<List<Map<String, dynamic>>> getPlaylistSongs(int playlistId) async {
    final Database db = await database;
    return await db.rawQuery('''
      SELECT s.*, ps.position, ps.added_at
      FROM songs s
      INNER JOIN playlist_songs ps ON s.id = ps.song_id
      WHERE ps.playlist_id = ?
      ORDER BY ps.position ASC
    ''', [playlistId]);
  }

  Future<int> removeSongFromPlaylist(int playlistId, int songId) async {
    final Database db = await database;
    return await db.delete(
      'playlist_songs',
      where: 'playlist_id = ? AND song_id = ?',
      whereArgs: [playlistId, songId],
    );
  }

  Future<void> updateSongPosition(int playlistId, int songId, int newPosition) async {
    final Database db = await database;
    await db.update(
      'playlist_songs',
      {'position': newPosition},
      where: 'playlist_id = ? AND song_id = ?',
      whereArgs: [playlistId, songId],
    );
  }
}