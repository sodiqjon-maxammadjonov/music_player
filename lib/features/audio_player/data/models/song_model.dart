import 'package:on_audio_query/on_audio_query.dart' as audio_query;
import '../../domain/entities/song.dart';

class LocalSongModel extends Song {
  LocalSongModel({
    required String id,
    required String title,
    required String artist,
    required String path,
  }) : super(
    id: id,
    title: title,
    artist: artist,
    path: path,
  );

  factory LocalSongModel.fromSongModel(audio_query.SongModel song) {
    return LocalSongModel(
      id: song.id.toString(),
      title: song.title,
      artist: song.artist ?? 'Unknown',
      path: song.uri ?? '',
    );
  }
}