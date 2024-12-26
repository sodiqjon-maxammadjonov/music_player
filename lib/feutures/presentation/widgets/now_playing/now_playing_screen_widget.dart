import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/song_entity.dart';
import 'components/album_art.dart';
import 'components/now_playing_bottom_panel.dart';
import 'components/top_actions.dart';

class NowPlayingScreen extends StatelessWidget {
  final SongEntity currentSong;
  final bool isPlaying;

  const NowPlayingScreen({
    Key? key,
    required this.currentSong,
    required this.isPlaying,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: TopActions(
          songId: currentSong.id,
          isFavorite: currentSong.isFavorite,
          onBack: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: AlbumArt(
                songId: currentSong.id,
                isPlaying: isPlaying,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: NowPlayingBottomPanel(
              currentSong: currentSong,
              isPlaying: isPlaying,
            ),
          ),
        ],
      ),
    );
  }
}
