import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicList extends StatefulWidget {
  final List<File> music;
  final List<String> folders;

  MusicList({super.key, required this.music, required this.folders});

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> with SingleTickerProviderStateMixin {
  int? currentPlayingIndex;
  late AudioPlayer _audioPlayer;
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  Duration _totalDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _tabController = TabController(length: 2, vsync: this);

    // Musiqa davomiyligini va joriy pozitsiyani olish
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _totalDuration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  void playMusic(int index) {
    if (currentPlayingIndex != null && currentPlayingIndex != index) {
      _audioPlayer.stop();
    }

    if (currentPlayingIndex == index) {
      if (_audioPlayer.state == PlayerState.playing) {
        _audioPlayer.pause();
      } else {
        _audioPlayer.resume();
      }
    } else {
      _audioPlayer.setSource(UrlSource(widget.music[index].path));
      _audioPlayer.resume();
      currentPlayingIndex = index;
    }
    setState(() {});
  }

  void playNextSong() {
    if (currentPlayingIndex != null && currentPlayingIndex! < widget.music.length - 1) {
      playMusic(currentPlayingIndex! + 1);
    }
  }

  void playPreviousSong() {
    if (currentPlayingIndex != null && currentPlayingIndex! > 0) {
      playMusic(currentPlayingIndex! - 1);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String getFileName(String path) {
    return path.split('/').last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.music_note,
                            size: 80.0,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                    bottom: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.white,
                      indicatorWeight: 3.0,
                      tabs: [
                        Tab(
                          text: 'Musiqalar',
                        ),
                        Tab(
                          text: 'Papkalar',
                        ),
                      ],
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  ListView.builder(
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: widget.music.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        elevation: 1,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => playMusic(index),
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                currentPlayingIndex == index && _audioPlayer.state == PlayerState.playing
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_filled,
                                color: Colors.deepPurple,
                                size: 30,
                              ),
                            ),
                            title: Text(
                              getFileName(widget.music[index].path),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            subtitle: Text(
                              // 'Unknown Artist',
                              widget.music[index].uri.userInfo,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => buildMoreOptionsSheet(index),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  GridView.builder(
                    padding: EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: widget.folders.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2,
                        child: InkWell(
                          onTap: () {
                            // Papka ochilganda
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.folder,
                                size: 48,
                                color: Colors.amber,
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  getFileName(widget.folders[index]),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.music_note, color: Colors.deepPurple),
            title: Text(
              currentPlayingIndex == null
                  ? 'Musiqa o\'ynatilmayapti'
                  : getFileName(widget.music[currentPlayingIndex!].path),
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: 1,
            ),
            subtitle: Text(currentPlayingIndex == null
                ? ''
                : widget.music[currentPlayingIndex!].path,maxLines: 1,),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  onPressed: playPreviousSong,
                ),
                IconButton(
                  icon: Icon(currentPlayingIndex == null
                      ? Icons.play_circle_filled
                      : (_audioPlayer.state == PlayerState.playing
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled)),
                  onPressed: currentPlayingIndex == null
                      ? null
                      : () => playMusic(currentPlayingIndex!),
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: playNextSong,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMoreOptionsSheet(int index) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Ulashish'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.playlist_add),
            title: Text('Pleylistga qo\'shish'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Ma\'lumot'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
