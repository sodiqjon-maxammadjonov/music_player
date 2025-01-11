import 'package:flutter/material.dart';
import 'package:music_player/src/data/model/music_model.dart';
import 'package:music_player/src/presentation/widgets/music/music_list_widget.dart';
class MusicList extends StatelessWidget {
  final List<Song> song;
  
  const MusicList({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 8,
      radius: Radius.circular(10),
      interactive: true,
      child: ListView.builder(
        itemCount: song.length,
        itemBuilder: (context, index) {
          return MusicListWidget(song: song[index], onTap: () {});
        },
      ),
    );
  }
}
