import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/audio_player_bloc.dart';
import '../widgets/player_controls.dart';

class AudioPlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
      ),
      body: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
        builder: (context, state) {
          if (state is AudioPlayerLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AudioPlayerLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.songs.length,
                    itemBuilder: (context, index) {
                      final song = state.songs[index];
                      return ListTile(
                        title: Text(song.title),
                        subtitle: Text(song.artist),
                        onTap: () {
                          context.read<AudioPlayerBloc>().add(PlaySong(song));
                        },
                      );
                    },
                  ),
                ),
                if (state.currentSong != null)
                  PlayerControls(
                    song: state.currentSong!,
                    isPlaying: state.isPlaying,
                  ),
              ],
            );
          } else if (state is AudioPlayerError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}