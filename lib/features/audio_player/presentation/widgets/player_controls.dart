import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/song.dart';
import '../bloc/audio_player_bloc.dart';

class PlayerControls extends StatelessWidget {
  final Song song;
  final bool isPlaying;

  const PlayerControls({
    required this.song,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            song.title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          Text(
            song.artist,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.skip_previous),
                onPressed: () {
                  context.read<AudioPlayerBloc>().add(PreviousSong());
                },
              ),
              IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  context.read<AudioPlayerBloc>().add(
                    isPlaying ? PauseSong() : PlaySong(song),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.skip_next),
                onPressed: () {
                  context.read<AudioPlayerBloc>().add(NextSong());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}