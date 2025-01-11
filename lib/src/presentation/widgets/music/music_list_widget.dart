import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player/src/data/model/music_model.dart';

class MusicListWidget extends StatelessWidget {
  final Song song;
  final Function()? onTap;
  const MusicListWidget({
    Key? key,
    required this.song, this.onTap,
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
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: ClipRRect(
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
            ),
          ),
        ),
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
              song.artist ?? "Noma'lum artist",
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
      trailing: IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_rounded)),
    );
  }
}
