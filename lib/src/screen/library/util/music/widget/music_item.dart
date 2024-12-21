import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../bloc/library_bloc.dart';
import 'music_action_sheet.dart';

class MusicItem extends StatefulWidget {
  final QueryArtworkWidget? image;
  final String? musicName;
  final String? artistName;
  final int? duration;
  final bool isPlaying;
  final SongModel song;

  const MusicItem({
    Key? key,
    required this.musicName,
    required this.artistName,
    required this.duration,
    required this.image,
    required this.isPlaying,
    required this.song,
  }) : super(key: key);

  @override
  _MusicItemState createState() => _MusicItemState();
}

class _MusicItemState extends State<MusicItem> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  static const int _maxTextLength = 20;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * 3.1416).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  @override
  void didUpdateWidget(covariant MusicItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _animationController.repeat();
    }
    if (!widget.isPlaying && oldWidget.isPlaying) {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildTitleWidget(String title, TextStyle? style) {
    final needsMarquee = title.length > _maxTextLength;

    if (needsMarquee) {
      return SizedBox(
        height: 20,
        child: Marquee(
          text: title,
          style: style,
          scrollAxis: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          blankSpace: 30.0,
          velocity: 30.0,
          pauseAfterRound: const Duration(seconds: 1),
          startPadding: 10.0,
          accelerationDuration: const Duration(seconds: 1),
          accelerationCurve: Curves.easeIn,
          decelerationDuration: const Duration(seconds: 1),
          decelerationCurve: Curves.easeOut,
        ),
      );
    } else {
      return Text(
        title,
        style: style,
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: widget.image != null
                ? AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: widget.image,
                );
              },
            )
                : CircleAvatar(
              radius: 30,
              backgroundColor: theme.colorScheme.secondary,
              child: Icon(
                Icons.music_note,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleWidget(
                  widget.musicName ?? "Unknown Title",
                  theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildTitleWidget(
                        widget.artistName ?? "Unknown Artist",
                        theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                    ),
                    Text(
                      _formatDuration(widget.duration ?? 0),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return BlocProvider.value(
                    value: BlocProvider.of<LibraryBloc>(context),
                    child: MusicActionsSheet(
                      song: widget.song,
                      parentContext: context,
                      onActionComplete: () {
                        setState(() {});
                      },
                    ),
                  );
                },
              );
            },
            icon: const Icon(CupertinoIcons.ellipsis_vertical),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int duration) {
    final minutes = (duration ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((duration % 60000) ~/ 1000).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
