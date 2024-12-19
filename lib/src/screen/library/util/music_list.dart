import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_player/src/util/widgets/music_cart_item.dart';

class MusicList extends StatefulWidget {
  final List<File> music;

  MusicList({super.key, required this.music});

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  int? currentPlayingIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.music.length,
        itemBuilder: (context, index) {
          return MusicItemCard(
            musicFile: widget.music[index],
            isPlaying: currentPlayingIndex == index,
            onTap: () {
              setState(() {
                currentPlayingIndex = index;
              });
            },
          );
        },
      ),
    );
  }
}