import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/feutures/domain/entities/song_entity.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../bloc/music/music_bloc.dart';

class MusicListWidget extends StatelessWidget {
  final List<SongEntity> songs;

  MusicListWidget({required this.songs});

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          leading: QueryArtworkWidget(
            id: int.parse(song.id),
            type: ArtworkType.AUDIO,
            nullArtworkWidget: Icon(
              Icons.music_note,
              size: 48,
              color: Colors.grey,
            ),
            artworkBorder: BorderRadius.circular(8.0),
            artworkFit: BoxFit.cover,
          ),
          title: Text(
            song.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            song.artist,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      song.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: song.isFavorite ? Colors.red : null,
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
              Text(
                formatDuration(song.duration), // Pass the Duration directly
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          onTap: () {
            context.read<MusicBloc>().add(PlaySongEvent(song));
          },
        );
      },
    );
  }
}
