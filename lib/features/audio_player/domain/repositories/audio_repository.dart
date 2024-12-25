import '../entities/song.dart';

abstract class AudioRepository {
  Future<List<Song>> getSongs();
  Future<void> playSong(Song song);
  Future<void> pauseSong();
  Future<void> nextSong();
  Future<void> previousSong();
}