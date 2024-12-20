// import 'package:flutter/material.dart';
// import 'package:music_player/src/functions/library/library_music_function.dart';
// import 'package:on_audio_query/on_audio_query.dart';
//
// class Musicc extends StatefulWidget {
//   @override
//   _MusicScreenState createState() => _MusicScreenState();
// }
//
// class _MusicScreenState extends State<Musicc> {
//   final LibraryMusicFunction _musicController = LibraryMusicFunction();
//
//   @override
//   void initState() {
//     super.initState();
//     _musicController.fetchSongs(() {
//       setState(() {});
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Musiqalar"),
//       ),
//       body: _musicController.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: _musicController.songs.length,
//         itemBuilder: (context, index) {
//           final song = _musicController.songs[index];
//           return ListTile(
//             leading: QueryArtworkWidget(
//               id: song.id,
//               type: ArtworkType.AUDIO,
//               nullArtworkWidget: const Icon(Icons.music_note),
//             ),
//             title: Text(song.title),
//             subtitle: Text(song.artist ?? "Unknown Artist"),
//             onTap: () {
//               // Qo'shiq bosilganda ishlash
//             },
//           );
//         },
//       ),
//     );
//   }
// }
