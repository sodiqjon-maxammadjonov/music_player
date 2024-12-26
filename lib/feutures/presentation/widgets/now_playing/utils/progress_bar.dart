import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final Duration duration;
  final Duration position;
  final Function(Duration)? onSeek;

  const ProgressBar({
    Key? key,
    required this.duration,
    this.position = Duration.zero,
    this.onSeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          ),
          child: Slider(
            value: position.inMilliseconds.toDouble(),
            max: duration.inMilliseconds.toDouble(),
            onChanged: (value) {
              onSeek?.call(Duration(milliseconds: value.toInt()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(position)),
              Text(_formatDuration(duration)),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}