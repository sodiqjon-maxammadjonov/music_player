import 'package:flutter/material.dart';

class SongInfo extends StatelessWidget {
  final String title;
  final String artist;

  const SongInfo({
    Key? key,
    required this.title,
    required this.artist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          artist,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
