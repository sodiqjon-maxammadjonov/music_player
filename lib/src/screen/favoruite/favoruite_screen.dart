import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../model/music/music.dart';

class Musicc extends StatefulWidget {
  final String musicDirectory;

  Musicc({super.key, required this.musicDirectory});

  @override
  State<Musicc> createState() => _MusicListState();
}

class _MusicListState extends State<Musicc> {
  late AudioPlayer _audioPlayer;
  List<Music> musicList = [];
  int? currentPlayingIndex;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadMusic();
  }

  Future<void> _loadMusic() async {
    musicList = await MusicRepository.getMusicList(widget.musicDirectory);
    setState(() {});
  }

  void playMusic(int index) {
    if (currentPlayingIndex != null && currentPlayingIndex != index) {
      _audioPlayer.stop();
    }
    if (currentPlayingIndex == index) {
      _audioPlayer.pause();
      currentPlayingIndex = null;
    } else {
      _audioPlayer.setSource(UrlSource(musicList[index].path));
      _audioPlayer.resume();
      currentPlayingIndex = index;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Musiqalar'),
      ),
      body: musicList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: musicList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    currentPlayingIndex == index
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color: Colors.deepPurple,
                    size: 30,
                  ),
                ),
                title: Text(
                  musicList[index].name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  musicList[index].artist,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    // Qoshimcha parametrlar uchun
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
