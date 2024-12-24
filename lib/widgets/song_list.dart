import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/audio/audio_bloc.dart';
import '../models/song.dart';

class SongsList extends StatelessWidget {
  final List<Song> songs;
  final bool showAlbum;

  const SongsList({
    required this.songs,
    this.showAlbum = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return ListTile(
          leading: SongArtwork(
            artwork: song.artwork,
            size: 50,
          ),
          title: Text(song.title),
          subtitle: Text(
            showAlbum && song.album != null
                ? '${song.artist} • ${song.album}'
                : song.artist,
          ),
          trailing: SongPopupMenu(song: song),
          onTap: () {
            context.read<AudioBloc>().add(PlaySong(
              song,
              playlist: songs,
              playlistIndex: index,
            ));
          },
        );
      },
    );
  }
}
