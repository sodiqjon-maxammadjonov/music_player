import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumArt extends StatefulWidget {
  final String songId;
  final bool isPlaying;

  const AlbumArt({
    Key? key,
    required this.songId,
    required this.isPlaying,
  }) : super(key: key);

  @override
  State<AlbumArt> createState() => _AlbumArtState();
}

class _AlbumArtState extends State<AlbumArt> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AlbumArt oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      widget.isPlaying ? _controller.repeat() : _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: widget.isPlaying ? _controller.value * 2 * 3.14159 : 0,
          child: Hero(
            tag: 'album_art_${widget.songId}',
            child: QueryArtworkWidget(
              id: int.parse(widget.songId),
              type: ArtworkType.AUDIO,
              nullArtworkWidget: const Icon(Icons.music_note_rounded),
              artworkBorder: BorderRadius.circular(200),
              artworkFit: BoxFit.cover,
              artworkHeight: double.infinity,
              artworkWidth: double.infinity,
            ),
          ),
        );
      },
    );
  }
}