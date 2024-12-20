// import 'dart:io';
//
// class Music {
//   final int id;
//   final String path;
//   final String name;
//   final String artist;
//   final Duration duration;
//   final String image;
//
//   Music({
//     required this.id,
//     required this.path,
//     required this.name,
//     required this.artist,
//     required this.duration,
//     required this.image,
//   });
//
//   factory Music.fromFile(File musicFile, File imageFile) {
//     String path = musicFile.path;
//     String name = musicFile.uri.pathSegments.last;
//     String artist = 'Unknown Artist';
//     Duration duration = Duration(seconds: 180);
//     String image = imageFile.path;
//
//     return Music(
//       id: DateTime.now().millisecondsSinceEpoch,
//       path: path,
//       name: name,
//       artist: artist,
//       duration: duration,
//       image: image,
//     );
//   }
// }
//
// class MusicRepository {
//   static Future<List<Music>> getMusicList(String musicDirectory) async {
//     final directory = Directory(musicDirectory);
//     final musicFiles = directory.listSync().where((file) {
//       return file.path.endsWith('.mp3');
//     }).toList();
//
//     List<Music> musicList = [];
//     for (var file in musicFiles) {
//       String imagePath = file.path.replaceFirst('.mp3', '.jpg');
//       File imageFile = File(imagePath);
//
//       musicList.add(Music.fromFile(File(file.path), imageFile));
//     }
//     return musicList;
//   }
// }
