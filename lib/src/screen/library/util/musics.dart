import 'package:flutter/material.dart';
import 'package:music_player/src/screen/library/util/music/music_list.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Musics extends StatefulWidget {
  final List<SongModel> music;
  final List<String> folders;

  Musics({super.key, required this.music, required this.folders});

  @override
  State<Musics> createState() => _MusicListState();
}

class _MusicListState extends State<Musics> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  DefaultTabController(
        length: 4,
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 150.0,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                    ),
                  ),
                ),
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'Musics'),
                    Tab(text: 'Folders'),
                    Tab(text: 'Playlists'),
                    Tab(text: 'Favorites'),
                  ],
                ),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  children: [
                    MusicList(music: widget.music),
                    Center(child: Text('Favorites Content')),
                    Center(child: Text('Settings Content')),
                    Center(child: Text('Favorites Content')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}