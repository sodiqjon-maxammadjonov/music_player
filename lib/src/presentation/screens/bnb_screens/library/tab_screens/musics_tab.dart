import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/src/components/library/music/music_list.dart';
import 'package:music_player/src/presentation/bloc/music/music_bloc.dart';
import 'package:music_player/src/presentation/widgets/snackbar/snackbar.dart';

import '../../../../status/empty.dart';
import '../../../../status/failed.dart';

class MusicsTab extends StatefulWidget {
  const MusicsTab({super.key});

  @override
  State<MusicsTab> createState() => _MainScreenState();
}

class _MainScreenState extends State<MusicsTab> {
  final bloc = MusicBloc();

  @override
  void initState() {
    bloc.add(MusicLoadEvent(context: context));
    super.initState();
  }

  fetch() async {
    bloc.add(MusicLoadEvent(context: context));
    // Optionally, add a small delay if you want the refresh indicator to show briefly
    await Future.delayed(Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          SizedBox(
            height: height * .02,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => fetch(),
              child: BlocConsumer<MusicBloc, MusicState>(
                bloc: bloc,
                listenWhen: (previous, current) => current is MusicActionState,
                buildWhen: (previous, current) => current is! MusicActionState,
                listener: (context, state) {
                  if (state is MusicErrorState) {
                    CustomSnackbar.show(
                        context: context,
                        message: state.message,
                        type: SnackbarType.error);
                  }
                },
                builder: (context, state) {
                  print('current state is $state');
                  if (state is MusicLoadedState) {
                    print('Music Loaded: ${state.song.length} songs loaded'); // Print music loaded state
                    return MusicList(song: state.song);
                  } else if (state is MusicEmptyState) {
                    print('No music found'); // Print empty state
                    return Empty(message: 'Empty',);
                  } else if (state is MusicFailedState) {
                    print('Music Load Failed'); // Print failure state
                    return Failed(
                      message: 'Failed',
                      onRetry: () {
                        bloc.add(MusicLoadEvent(context: context));
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
