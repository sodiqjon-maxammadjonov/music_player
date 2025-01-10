import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'full_screen.dart';

class MusicListWidget extends StatelessWidget {
  final SongModel song;
  final bool isPlaying;
  final bool isPaused;
  final Function()? onTap;
  final Function()? onShare;
  final Function()? onEdit;
  final Function()? onDelete;
  final Function()? onPlay;
  final Function()? onPause;
  final Function()? onNext;
  final Function()? onPrevious;
  final Function()? onRepeat;
  final Function()? onShuffle;
  final Function()? onAddToFavorite;
  final Function()? onAddToPlaylist;
  final bool isRepeat;
  final bool isShuffle;
  final bool isFavorite;

  const MusicListWidget({
    Key? key,
    required this.song,
    this.isPlaying = false,
    this.isPaused = false,
    this.onTap,
    this.onShare,
    this.onEdit,
    this.onDelete,
    this.onPlay,
    this.onPause,
    this.onNext,
    this.onPrevious,
    this.onRepeat,
    this.onShuffle,
    this.onAddToFavorite,
    this.onAddToPlaylist,
    this.isRepeat = false,
    this.isShuffle = false,
    this.isFavorite = false,
  }) : super(key: key);

  String _formatDuration(int milliseconds) {
    Duration duration = Duration(milliseconds: milliseconds);
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MusicPlayerFullScreen(
              song: song,
              isPlaying: isPlaying,
              position: Duration.zero, // Position will be updated in player
              duration: Duration(milliseconds: song.duration ?? 0),
              onPlay: onPlay,
              onPause: onPause,
              onNext: onNext,
              onPrevious: onPrevious,
              onRepeat: onRepeat,
              onShuffle: onShuffle,
              onAddToFavorite: onAddToFavorite,
              onAddToPlaylist: onAddToPlaylist,
              isRepeat: isRepeat,
              isShuffle: isShuffle,
              isFavorite: isFavorite,
            ),
          ),
        );
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: QueryArtworkWidget(
              id: song.id,
              type: ArtworkType.AUDIO,
              artworkBorder: BorderRadius.circular(12),
              artworkWidth: 50,
              artworkHeight: 50,
              artworkFit: BoxFit.cover,
              nullArtworkWidget: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.music_note_rounded,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),
          if (isPlaying)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: theme.primaryColor,
              ),
            )
          else if (isPaused)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.pause_rounded,
                color: theme.primaryColor,
              ),
            ),
        ],
      ),
      title: song.title.length > 20
          ? SizedBox(
        height: 20,
        child: Marquee(
          text: song.title,
          style: theme.textTheme.titleMedium,
          scrollAxis: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          blankSpace: 20.0,
          velocity: 30.0,
          pauseAfterRound: const Duration(seconds: 2),
          startPadding: 10.0,
          accelerationDuration: const Duration(seconds: 1),
          accelerationCurve: Curves.linear,
          decelerationDuration: const Duration(milliseconds: 500),
          decelerationCurve: Curves.easeOut,
        ),
      )
          : Text(
        song.title,
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              song.artist.toString(),
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            _formatDuration(song.duration ?? 0),
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        icon: Icon(
          Icons.more_vert,
          color: theme.iconTheme.color,
        ),
        onSelected: (value) {
          switch (value) {
            case 'share':
              onShare.call();
              break;
            case 'edit':
              onEdit?.call();
              break;
            case 'delete':
              onDelete?.call();
              break;
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'share',
            child: Row(
              children: [
                Icon(Icons.share, color: theme.iconTheme.color),
                const SizedBox(width: 8),
                Text('Ulashish', style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, color: theme.iconTheme.color),
                const SizedBox(width: 8),
                Text('Tahrirlash', style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, color: theme.iconTheme.color),
                const SizedBox(width: 8),
                Text('O\'chirish', style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}