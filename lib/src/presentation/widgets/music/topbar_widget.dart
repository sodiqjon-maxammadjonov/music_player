import 'package:flutter/material.dart';

class TopBarWidget extends StatelessWidget {
  const TopBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
          ),
          Text(
            'Now Playing',
            style: theme.textTheme.titleMedium,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
    );
  }
}