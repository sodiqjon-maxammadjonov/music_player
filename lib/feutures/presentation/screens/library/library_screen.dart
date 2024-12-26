import 'package:flutter/material.dart';
import 'package:music_player/feutures/presentation/screens/library/tab_screens/albums_screen.dart';
import 'package:music_player/feutures/presentation/screens/library/tab_screens/artists_screen.dart';
import 'package:music_player/feutures/presentation/screens/library/tab_screens/musics_screen.dart';
import 'package:music_player/feutures/presentation/screens/library/tab_screens/playlists_screen.dart';

class LibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: const Text('Library'),
          elevation: 0,
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Music'),
              Tab(text: 'Playlists'),
              Tab(text: 'Albums'),
              Tab(text: 'Artists'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MusicsScreen(),
            PlaylistsScreen(),
            AlbumsScreen(),
            ArtistsScreen(),
          ],
        ),
      ),
    );
  }
}
