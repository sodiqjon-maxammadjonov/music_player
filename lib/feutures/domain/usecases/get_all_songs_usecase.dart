import '../entities/song_entity.dart';
import '../repositories/music_repository.dart';

class GetAllSongsUseCase {
  final MusicRepository repository;

  GetAllSongsUseCase(this.repository);

  Future<List<SongEntity>> call() async {
    return await repository.getAllSongs();
  }
}