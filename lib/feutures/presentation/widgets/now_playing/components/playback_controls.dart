import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/music/music_bloc.dart';
import '../../playback/buttons.dart';

class PlaybackControls extends StatelessWidget {
  final bool isPlaying;

  const PlaybackControls({
    Key? key,
    required this.isPlaying,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicBloc, MusicState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ShuffleButton(
              isEnabled: state.isShuffleEnabled,
              onPressed: () => _onShufflePressed(context),
            ),
            PreviousButton(
              onPressed: () => _onPreviousPressed(context),
            ),
            PlayPauseButton(
              isPlaying: isPlaying,
              onPressed: () => _onPlayPausePressed(context),
            ),
            NextButton(
              onPressed: () => _onNextPressed(context),
            ),
            RepeatButton(
              mode: state.repeatMode,
              onPressed: () => _onRepeatPressed(context),
            ),
          ],
        );
      },
    );
  }

  void _onShufflePressed(BuildContext context) {
    context.read<MusicBloc>().add(ToggleShuffleEvent());
  }

  void _onPreviousPressed(BuildContext context) {
    context.read<MusicBloc>().add( PreviousSongEvent());
  }

  void _onPlayPausePressed(BuildContext context) {
    context.read<MusicBloc>().add(TogglePlayPauseEvent());
  }

  void _onNextPressed(BuildContext context) {
    context.read<MusicBloc>().add(NextSongEvent());
  }

  void _onRepeatPressed(BuildContext context) {
    context.read<MusicBloc>().add( ToggleRepeatEvent());
  }
}
