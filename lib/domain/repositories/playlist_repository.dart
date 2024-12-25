import '../../data/models/playlist_model.dart';

abstract class PlaylistRepository {
  Future<int> createPlaylist(PlaylistModel playlist);
  Future<List<PlaylistModel>> getAllPlaylists();
}