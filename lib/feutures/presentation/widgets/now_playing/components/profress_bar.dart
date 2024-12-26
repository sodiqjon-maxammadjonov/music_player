import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/music/music_bloc.dart';
import '../utils/duration_formatter.dart';

class ProgressBar extends StatelessWidget {
  final Duration duration;

  const ProgressBar({
    Key? key,
    required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicBloc, MusicState>(
      builder: (context, state) {
        final currentPosition = state.currentPosition ?? Duration.zero;

        return Column(
          children: [
            Slider(
              value: currentPosition.inSeconds.toDouble(),
              max: duration.inSeconds.toDouble(),
              onChanged: (value) => _onSeekChanged(context, value),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DurationFormatter.format(currentPosition)),
                  Text(DurationFormatter.format(duration)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _onSeekChanged(BuildContext context, double value) {
    final newPosition = Duration(seconds: value.toInt());
    context.read<MusicBloc>().add(SeekToEvent(newPosition));
  }
}
