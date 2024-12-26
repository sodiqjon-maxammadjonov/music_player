import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/music_bloc.dart';

class MusicPlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicBloc, MusicState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return Center(child: Text(state.error!));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Music Player'),
            actions: [
              IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  // Navigate to favorites page
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.songs.length,
                  itemBuilder: (context, index) {
                    final song = state.songs[index];
                    return ListTile(
                      title: Text(song.title),
                      subtitle: Text(song.artist),
                      leading: Icon(Icons.music_note),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              song.isFavorite ? Icons.favorite : Icons.favorite_border,
                            ),
                            onPressed: () {
                              context.read<MusicBloc>().add(
                                ToggleFavoriteEvent(song.id),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              context.read<MusicBloc>().add(
                                DeleteSongEvent(song.id),
                              );
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        context.read<MusicBloc>().add(PlaySongEvent(song));
                      },
                    );
                  },
                ),
              ),
              if (state.currentSong != null) ...[
                Divider(height: 1),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        state.currentSong!.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        state.currentSong!.artist,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.skip_previous),
                            onPressed: () {
                              context.read<MusicBloc>().add(PreviousSongEvent());
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              state.isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                            onPressed: () {
                              context.read<MusicBloc>().add(TogglePlayPauseEvent());
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.skip_next),
                            onPressed: () {
                              context.read<MusicBloc>().add(NextSongEvent());
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
