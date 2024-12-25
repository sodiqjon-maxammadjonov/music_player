import '../../domain/repositories/audio_repository.dart';
import '../datasources/local/database_helper.dart';
import '../models/audio_model.dart';

class AudioRepositoryImpl implements AudioRepository {
  final DatabaseHelper databaseHelper;

  AudioRepositoryImpl({required this.databaseHelper});

  @override
  Future<int> insertAudio(AudioModel audio) async {
    return await databaseHelper.insertAudio(audio.toMap());
  }

  @override
  Future<List<AudioModel>> getAllAudios() async {
    final List<Map<String, dynamic>> maps = await databaseHelper.getAllAudios();
    return List.generate(maps.length, (i) {
      return AudioModel.fromMap(maps[i]);
    });
  }

  @override
  Future<List<AudioModel>> getFavoriteAudios() async {
    final List<Map<String, dynamic>> maps = await databaseHelper.getFavoriteAudios();
    return List.generate(maps.length, (i) {
      return AudioModel.fromMap(maps[i]);
    });
  }
}