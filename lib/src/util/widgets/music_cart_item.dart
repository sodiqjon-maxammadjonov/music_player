import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicItemCard extends StatefulWidget {
  final File musicFile;
  final VoidCallback? onTap;
  final bool isPlaying;

  const MusicItemCard({
    Key? key,
    required this.musicFile,
    this.onTap,
    this.isPlaying = false,
  }) : super(key: key);

  @override
  _MusicItemCardState createState() => _MusicItemCardState();
}

class _MusicItemCardState extends State<MusicItemCard> {
  late AudioPlayer _audioPlayer;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Load local audio file using setSource with FileSource
    _audioPlayer.setSource(UrlSource(widget.musicFile.path)).then((_) {
      _audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _duration = duration;
        });
      });
    });
  }

  String getMusicTitle(String filename) {
    final nameWithoutExtension = filename.split('.').first;
    final parts = nameWithoutExtension.split(' - ');
    if (parts.length > 1) {
      return parts[1];
    }
    return nameWithoutExtension;
  }

  String getArtistName(String filename) {
    final nameWithoutExtension = filename.split('.').first;
    final parts = nameWithoutExtension.split(' - ');
    if (parts.length > 1) {
      return parts[0];
    }
    return 'Noma\'lum ijrochi';
  }

  String getFormattedDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String getFormattedSize(int sizeInBytes) {
    final sizeInMB = sizeInBytes / (1024 * 1024);
    return '${sizeInMB.toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filename = widget.musicFile.uri.pathSegments.last;

    final duration = _duration; // Real duration from the audio file
    final size = widget.musicFile.lengthSync(); // Get the file size in bytes

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: widget.isPlaying
            ? theme.colorScheme.primary.withOpacity(0.1)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.music_note,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 30,
                      ),
                      if (widget.isPlaying)
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.play_arrow,
                            color: theme.colorScheme.onPrimary,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getMusicTitle(filename),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        getArtistName(filename),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 4),
                          Text(
                            getFormattedDuration(duration),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(width: 16),
                          Icon(
                            Icons.storage,
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 4),
                          Text(
                            getFormattedSize(size),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite_border,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {
                        // Add favorite functionality here
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {
                        // Show more options here
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
