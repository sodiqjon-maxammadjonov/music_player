import 'package:flutter/material.dart';

class SongDetailsWidget extends StatelessWidget {
  final String title;
  final String artistName;
  const SongDetailsWidget({super.key, required this.title, required this.artistName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return  Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:  theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                artistName,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface
                      .withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.favorite_border_rounded,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );

  }
}