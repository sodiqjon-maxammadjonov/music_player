import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/music/music_bloc.dart';

class TopActions extends StatelessWidget {
  final String songId;
  final bool isFavorite;
  final VoidCallback onBack;

  const TopActions({
    Key? key,
    required this.songId,
    required this.isFavorite,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.expand_more),
        onPressed: onBack,
      ),
      actions: [
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: () => _onFavoritePressed(context),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showOptionsMenu(context),
        ),
      ],
    );
  }

  void _onFavoritePressed(BuildContext context) {
    context.read<MusicBloc>().add(ToggleFavoriteEvent(songId));
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('Add to playlist'),
              onTap: () {
                context.read<MusicBloc>().add(AddToPlaylistEvent(songId));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete song'),
              onTap: () {
                context.read<MusicBloc>().add(DeleteSongEvent(songId));
                Navigator.pop(context);
                Navigator.pop(context); // Close now playing screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                // You need to pass song path here
                context.read<MusicBloc>().add(ShareSongEvent(''));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}