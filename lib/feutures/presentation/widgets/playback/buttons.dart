import 'package:flutter/material.dart';

import '../../../../core/widgets/repeat_mode.dart';

class ShuffleButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;

  const ShuffleButton({
    Key? key,
    required this.isEnabled,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.shuffle_rounded,
        color: isEnabled ? Theme.of(context).primaryColor : Colors.grey,
      ),
      onPressed: onPressed,
    );
  }
}

class PreviousButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PreviousButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.skip_previous_rounded),
      iconSize: 32,
      onPressed: onPressed,
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPressed;

  const PlayPauseButton({
    Key? key,
    required this.isPlaying,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
      ),
      iconSize: 48,
      onPressed: onPressed,
    );
  }
}

class NextButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NextButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.skip_next_rounded),
      iconSize: 32,
      onPressed: onPressed,
    );
  }
}

class RepeatButton extends StatelessWidget {
  final RepeatMode mode;
  final VoidCallback onPressed;

  const RepeatButton({
    Key? key,
    required this.mode,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color? color;

    switch (mode) {
      case RepeatMode.off:
        icon = Icons.repeat_rounded;
        color = Colors.grey;
      case RepeatMode.all:
        icon = Icons.repeat_rounded;
        color = Theme.of(context).primaryColor;
      case RepeatMode.one:
        icon = Icons.repeat_one_rounded;
        color = Theme.of(context).primaryColor;
    }

    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: onPressed,
    );
  }
}