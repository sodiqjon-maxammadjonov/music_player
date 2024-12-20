import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
  }

  String getMusicTitle(String filename) {
    final nameWithoutExtension = filename.split('.').first;
    final parts = nameWithoutExtension.split(' - ');
    return parts.length > 1 ? parts[1] : nameWithoutExtension;
  }

  String getArtistName(String filename) {
    final nameWithoutExtension = filename.split('.').first;
    final parts = nameWithoutExtension.split(' - ');
    return parts.length > 1 ? parts[0] : 'Noma\'lum ijrochi';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filename = widget.musicFile.uri.pathSegments.last;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: widget.isPlaying ? theme.colorScheme.primary.withOpacity(0.1) : theme.colorScheme.surface,
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
                  width: 50,
                  height: 50,
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
                          child: widget.isPlaying ? Icon(
                            Icons.pause,
                            color: theme.colorScheme.onPrimary,
                            size: 20,
                          ) : Icon(
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
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        getArtistName(filename),
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: (){},
                    icon: Icon(CupertinoIcons.ellipsis_vertical)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}