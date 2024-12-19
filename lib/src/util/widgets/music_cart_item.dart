import 'dart:io';
import 'package:flutter/material.dart';

class MusicItemCard extends StatelessWidget {
  final File musicFile;
  final VoidCallback? onTap;
  final bool isPlaying;

  const MusicItemCard({
    Key? key,
    required this.musicFile,
    this.onTap,
    this.isPlaying = false,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filename = musicFile.uri.pathSegments.last;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isPlaying
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
          onTap: onTap,
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
                      if (isPlaying)
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
                            '3:45',
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
                            '${(musicFile.lengthSync() / (1024 * 1024)).toStringAsFixed(1)} MB',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // O'ngdagi ikonkalar
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite_border,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {},
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
}
