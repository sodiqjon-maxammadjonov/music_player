import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song_model.dart';

class LocalAudioDatasource {
  final OnAudioQuery audioQuery;
  final AudioPlayer audioPlayer;

  LocalAudioDatasource({
    required this.audioQuery,
    required this.audioPlayer,
  });

  Future<List<LocalSongModel>> getSongs() async {
    final songs = await audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );

    return songs.map((song) => LocalSongModel.fromSongModel(song)).toList();
  }

  Future<void> playSong(String path) async {
    await audioPlayer.setFilePath(path);
    await audioPlayer.play();
  }

  Future<void> pauseSong() async {
    await audioPlayer.pause();
  }
}
