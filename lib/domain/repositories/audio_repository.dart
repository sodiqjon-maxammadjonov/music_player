import '../../data/models/audio_model.dart';

abstract class AudioRepository {
  Future<int> insertAudio(AudioModel audio);
  Future<List<AudioModel>> getAllAudios();
  Future<List<AudioModel>> getFavoriteAudios();
}