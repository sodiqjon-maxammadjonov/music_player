import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/audio/audio_bloc.dart';

class NowPlayingBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        if (state is AudioPlaying || state is AudioPaused) {
          final song = state is AudioPlaying ? state.song : (state as AudioPaused).song;
          final isPlaying = state is AudioPlaying;

          return Container(
            height: 75,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                AudioProgressBar(),
                // Controls
                Row(
                  children: [
                    // Artwork
                    SongArtwork(
                      artwork: song.artwork,
                      size: 60,
                    ),
                    // Song info
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              song.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              song.artist,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Controls
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.skip_previous),
                          onPressed: () {
                            // Handle previous
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
                          onPressed: () {
                            if (isPlaying) {
                              context.read<AudioBloc>().add(PauseSong());
                            } else {
                              context.read<AudioBloc>().add(ResumeSong());
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.skip_next),
                          onPressed: () {
                            // Handle next
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}