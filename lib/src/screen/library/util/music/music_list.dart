import 'package:flutter/material.dart';
import 'package:music_player/src/screen/library/util/music/widget/music_item.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicList extends StatefulWidget {
  final List<SongModel> music;

  const MusicList({super.key, required this.music});

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  List<bool> isPlayingList = [];

  @override
  void initState() {
    super.initState();
    isPlayingList = List.generate(widget.music.length, (index) => false);
  }

  void _togglePlayPause(int index) {
    setState(() {
      for (int i = 0; i < isPlayingList.length; i++) {
        if (i == index) {
          isPlayingList[i] = !isPlayingList[i];
        } else {
          isPlayingList[i] = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: widget.music.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _togglePlayPause(index),
            child: MusicItem(
              musicName: widget.music[index].displayNameWOExt,
              artistName: widget.music[index].artist ?? "Unknown Artist",
              duration: widget.music[index].duration ?? 0,
              image: QueryArtworkWidget(
                id: widget.music[index].id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: Icon(
                    Icons.music_note,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
              isPlaying: isPlayingList[index],
              song: widget.music[index],
            ),
          );
        },
      ),
    );
  }
}
