import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/feutures/domain/entities/song_entity.dart';
import 'package:music_player/feutures/presentation/widgets/now_playing/now_playing_screen_widget.dart';
import '../bloc/music/music_bloc.dart';

class CurrentSongWidget extends StatelessWidget {
  final SongEntity currentSong;
  final bool isPlaying;

  const CurrentSongWidget({
    Key? key,
    required this.currentSong,
    required this.isPlaying,
  }) : super(key: key);

  void _openNowPlayingScreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => NowPlayingScreen(
          currentSong: currentSong,
          isPlaying: isPlaying,
        ),
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset(0.0, 0.0);
          const curve = Curves.easeInOut;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openNowPlayingScreen(context),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Song title
            Text(
              currentSong.title,
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
            // Artist name
            Text(
              currentSong.artist.isNotEmpty ? currentSong.artist : "Unknown Artist",
              style: Theme.of(context).textTheme.titleSmall,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Playback controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous_rounded),
                  onPressed: () {
                    context.read<MusicBloc>().add(PreviousSongEvent());
                  },
                ),
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  ),
                  onPressed: () {
                    context.read<MusicBloc>().add(TogglePlayPauseEvent());
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next_rounded),
                  onPressed: () {
                    context.read<MusicBloc>().add(NextSongEvent());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
