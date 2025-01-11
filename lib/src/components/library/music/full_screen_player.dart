import 'package:flutter/material.dart';
import 'package:music_player/src/data/function/music/music_function.dart';
import 'package:music_player/src/data/model/music_model.dart';
import '../../../presentation/widgets/music/artwork_widget.dart';
import '../../../presentation/widgets/music/bottom_controls_widget.dart';
import '../../../presentation/widgets/music/controls_widget.dart';
import '../../../presentation/widgets/music/progress_bar.dart';
import '../../../presentation/widgets/music/song_data_list_widget.dart';
import '../../../presentation/widgets/music/topbar_widget.dart';

class FullScreenPlayer extends StatelessWidget {
  final Song song;

  const FullScreenPlayer({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.primary.withOpacity(0.1),
                  theme.colorScheme.surface,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Top Bar
                  const TopBarWidget(),

                  // Artwork Tab View Section
                  Flexible(
                    flex: 3,
                    child: ArtworkTabView(id: song.id),
                  ),

                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.06),
                      child: Column(
                        children: [
                          // Title and Favorite Button
                          SongDetailsWidget(
                            title: song.displayTitle,
                            artistName: song.displayArtist,
                          ),

                          // Progress Bar
                          const SizedBox(height: 24),
                          const ProgressBarWidget(),

                          // Controls
                          const SizedBox(height: 24),
                          const ControlsWidget(),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Section (Optional Controls)
                  Padding(
                      padding: EdgeInsets.all(constraints.maxWidth * 0.06),
                      // 24.0,
                      child: const BottomControlsWidget())
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
