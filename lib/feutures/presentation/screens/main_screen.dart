import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/feutures/presentation/screens/home/home_screen.dart';
import 'package:music_player/feutures/presentation/screens/library/library_screen.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/music/music_bloc.dart';
import '../widgets/current_song_widget.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: state.currentIndex,
                  children: [
                    HomeScreen(),
                    LibraryScreen(),
                  ],
                ),
              ),
              BlocBuilder<MusicBloc, MusicState>(
                builder: (context, state) {
                  if (state.currentSong == null) {
                    return SizedBox.shrink();
                  }

                  return CurrentSongWidget(
                    currentSong: state.currentSong!,
                    isPlaying: state.isPlaying,
                  );
                },
              ),
            ],
          ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              currentIndex: state.currentIndex,
              onTap: (index) {
                context.read<NavigationBloc>().add(
                  NavigationIndexChanged(index),
                );
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.library_music_rounded),
                  label: 'Library',
                ),
              ],
              backgroundColor: Theme.of(context).bottomAppBarTheme.color,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              type: BottomNavigationBarType.fixed,
              enableFeedback: false,
            ),
          ),
        );
      },
    );
  }
}
