import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/src/components/library/music/music_list.dart';
import 'package:music_player/src/presentation/bloc/music/music_bloc.dart';
import 'package:music_player/src/presentation/widgets/snackbar/snackbar.dart';

import '../../../../status/empty.dart';
import '../../../../status/failed.dart';

class MusicsTab extends StatelessWidget {
  const MusicsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          SizedBox(height: height * .02),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<MusicBloc>().add(MusicLoadEvent(context: context));
                await Future.delayed(Duration(milliseconds: 500));
              },
              child: BlocConsumer<MusicBloc, MusicState>(
                listenWhen: (previous, current) => current is MusicActionState,
                buildWhen: (previous, current) => current is! MusicActionState,
                listener: (context, state) {
                  if (state is MusicErrorState) {
                    CustomSnackbar.show(
                        context: context,
                        message: state.message,
                        type: SnackbarType.error
                    );
                  }
                },
                builder: (context, state) {
                  if (state is MusicLoadedState) {
                    return MusicList(song: state.song);
                  } else if (state is MusicEmptyState) {
                    return Empty(message: 'Empty');
                  } else if (state is MusicFailedState) {
                    return Failed(
                      message: 'Failed',
                      onRetry: () {
                        context.read<MusicBloc>().add(MusicLoadEvent(context: context));
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}