import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/library/library_bloc.dart';
import '../../widgets/song_list.dart';

class MusicsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        if (state is LibraryLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is LibraryError) {
          return Center(child: Text(state.message));
        }

        if (state is LibraryLoaded) {
          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: 'All'),
                    Tab(text: 'Albums'),
                    Tab(text: 'Artists'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      SongsList(songs: state.songs),
                      AlbumsGrid(albumSongs: state.albumSongs),
                      ArtistsList(artistSongs: state.artistSongs),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Center(child: Text('No music found'));
      },
    );
  }
}