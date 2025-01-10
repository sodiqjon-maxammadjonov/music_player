import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlayerFullScreen extends StatefulWidget {
  final SongModel song;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final Function()? onPlay;
  final Function()? onPause;
  final Function()? onNext;
  final Function()? onPrevious;
  final Function(Duration)? onSeek;
  final Function()? onRepeat;
  final Function()? onShuffle;
  final Function()? onAddToFavorite;
  final Function()? onAddToPlaylist;
  final bool isRepeat;
  final bool isShuffle;
  final bool isFavorite;

  const MusicPlayerFullScreen({
    Key? key,
    required this.song,
    required this.isPlaying,
    required this.position,
    required this.duration,
    this.onPlay,
    this.onPause,
    this.onNext,
    this.onPrevious,
    this.onSeek,
    this.onRepeat,
    this.onShuffle,
    this.onAddToFavorite,
    this.onAddToPlaylist,
    this.isRepeat = false,
    this.isShuffle = false,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  State<MusicPlayerFullScreen> createState() => _MusicPlayerFullScreenState();
}

class _MusicPlayerFullScreenState extends State<MusicPlayerFullScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_down, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: widget.isFavorite ? Colors.red : theme.iconTheme.color,
            ),
            onPressed: widget.onAddToFavorite,
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
            onSelected: (value) {
              if (value == 'playlist') widget.onAddToPlaylist?.call();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'playlist',
                child: Row(
                  children: [
                    Icon(Icons.playlist_add, color: theme.iconTheme.color),
                    const SizedBox(width: 8),
                    Text('Playlistga qo\'shish'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const Spacer(),
          // Rotating Album Art
          AnimatedBuilder(
            animation: _controller,
            builder: (_, child) {
              return Transform.rotate(
                angle: widget.isPlaying ? _controller.value * 2 * 3.14159 : 0,
                child: child,
              );
            },
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(125),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(125),
                child: QueryArtworkWidget(
                  id: widget.song.id,
                  type: ArtworkType.AUDIO,
                  artworkFit: BoxFit.cover,
                  nullArtworkWidget: Container(
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.music_note_rounded,
                      size: 80,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Song Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  widget.song.title,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.song.artist ?? 'Unknown Artist',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.textTheme.titleMedium?.color?.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Progress Slider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: theme.primaryColor,
                    inactiveTrackColor: theme.primaryColor.withValues(alpha: 0.2),
                    thumbColor: theme.primaryColor,
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  ),
                  child: Slider(
                    value: widget.position.inSeconds.toDouble(),
                    min: 0,
                    max: widget.duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      widget.onSeek?.call(Duration(seconds: value.toInt()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(widget.position),
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        _formatDuration(widget.duration),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  widget.isShuffle ? Icons.shuffle : Icons.shuffle_outlined,
                  color: widget.isShuffle ? theme.primaryColor : theme.iconTheme.color,
                ),
                onPressed: widget.onShuffle,
              ),
              IconButton(
                icon: Icon(Icons.skip_previous, color: theme.iconTheme.color),
                iconSize: 40,
                onPressed: widget.onPrevious,
              ),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primaryColor,
                ),
                child: IconButton(
                  icon: Icon(
                    widget.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  iconSize: 40,
                  onPressed: widget.isPlaying ? widget.onPause : widget.onPlay,
                ),
              ),
              IconButton(
                icon: Icon(Icons.skip_next, color: theme.iconTheme.color),
                iconSize: 40,
                onPressed: widget.onNext,
              ),
              IconButton(
                icon: Icon(
                  widget.isRepeat ? Icons.repeat_one : Icons.repeat,
                  color: widget.isRepeat ? theme.primaryColor : theme.iconTheme.color,
                ),
                onPressed: widget.onRepeat,
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}