import 'package:flutter/material.dart';
class BottomControlsWidget extends StatelessWidget {
  const BottomControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.devices_rounded),
          iconSize: 24,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.queue_music_rounded),
          iconSize: 24,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.share_rounded),
          iconSize: 24,
        ),
      ],
    );
  }
}