import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

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
    // Audios
    await db.execute('''
      CREATE TABLE audios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        artist TEXT,
        duration INTEGER NOT NULL,
        path TEXT NOT NULL,
        folder_path TEXT NOT NULL,
        is_favorite INTEGER DEFAULT 0
      )
    ''');

    // Playlists
    await db.execute('''
      CREATE TABLE playlists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');

    // playlist va audio boglanishi
    await db.execute('''
      CREATE TABLE playlist_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        playlist_id INTEGER NOT NULL,
        audio_id INTEGER NOT NULL,
        position INTEGER NOT NULL,
        FOREIGN KEY (playlist_id) REFERENCES playlists (id) ON DELETE CASCADE,
        FOREIGN KEY (audio_id) REFERENCES audios (id) ON DELETE CASCADE
      )
    ''');

    // Folders jadvali
    await db.execute('''
      CREATE TABLE folders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertAudio(Map<String, dynamic> audio) async {
    final db = await database;
    return await db.insert('audios', audio);
  }

  Future<List<Map<String, dynamic>>> getAllAudios() async {
    final db = await database;
    return await db.query('audios');
  }

  Future<List<Map<String, dynamic>>> getFavoriteAudios() async {
    final db = await database;
    return await db.query('audios', where: 'is_favorite = 1');
  }

  Future<int> updateAudio(Map<String, dynamic> audio) async {
    final db = await database;
    return await db.update(
      'audios',
      audio,
      where: 'id = ?',
      whereArgs: [audio['id']],
    );
  }

  Future<int> createPlaylist(Map<String, dynamic> playlist) async {
    final db = await database;
    return await db.insert('playlists', playlist);
  }

  Future<List<Map<String, dynamic>>> getAllPlaylists() async {
    final db = await database;
    return await db.query('playlists');
  }

  Future<int> addAudioToPlaylist(int playlistId, int audioId, int position) async {
    final db = await database;
    return await db.insert('playlist_items', {
      'playlist_id': playlistId,
      'audio_id': audioId,
      'position': position,
    });
  }

  Future<List<Map<String, dynamic>>> getPlaylistAudios(int playlistId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT a.* FROM audios a
      INNER JOIN playlist_items pi ON pi.audio_id = a.id
      WHERE pi.playlist_id = ?
      ORDER BY pi.position
    ''', [playlistId]);
  }

  Future<int> insertFolder(Map<String, dynamic> folder) async {
    final db = await database;
    return await db.insert('folders', folder);
  }

  Future<List<Map<String, dynamic>>> getAllFolders() async {
    final db = await database;
    return await db.query('folders');
  }

  Future<List<Map<String, dynamic>>> getAudiosInFolder(String folderPath) async {
    final db = await database;
    return await db.query(
      'audios',
      where: 'folder_path = ?',
      whereArgs: [folderPath],
    );
  }
}