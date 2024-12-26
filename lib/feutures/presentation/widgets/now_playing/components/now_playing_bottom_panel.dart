import 'package:flutter/material.dart';
import 'package:music_player/feutures/presentation/widgets/now_playing/components/playback_controls.dart';

import '../../../../domain/entities/song_entity.dart';
import '../utils/progress_bar.dart';
import '../utils/song_info.dart';

class NowPlayingBottomPanel extends StatelessWidget {
  final SongEntity currentSong;
  final bool isPlaying;

  const NowPlayingBottomPanel({
    Key? key,
    required this.currentSong,
    required this.isPlaying,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SongInfo(
            title: currentSong.title,
            artist: currentSong.artist,
          ),
          ProgressBar(
            duration: currentSong.duration,
          ),
          PlaybackControls(
            isPlaying: isPlaying,
          ),
        ],
      ),
    );
  }
}