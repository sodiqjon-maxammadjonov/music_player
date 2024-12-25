
import '../../domain/repositories/playlist_repository.dart';
import '../datasources/local/database_helper.dart';
import '../models/playlist_model.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  final DatabaseHelper databaseHelper;

  PlaylistRepositoryImpl({required this.databaseHelper});

  @override
  Future<int> createPlaylist(PlaylistModel playlist) async {
    return await databaseHelper.createPlaylist(playlist.toMap());
  }

  @override
  Future<List<PlaylistModel>> getAllPlaylists() async {
    final List<Map<String, dynamic>> maps = await databaseHelper.getAllPlaylists();
    return List.generate(maps.length, (i) {
      return PlaylistModel.fromMap(maps[i]);
    });
  }
}