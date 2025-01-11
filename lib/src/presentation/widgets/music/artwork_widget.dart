import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ArtworkTabView extends StatelessWidget {
  final int id;
  const ArtworkTabView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double cardMargin = constraints.maxWidth * 0.06;
          double cardRadius = 20.0;

          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                // Tab Bar
                TabBar(
                  indicatorColor: theme.colorScheme.primary,
                  dividerColor: Colors.transparent,
                  labelColor: theme.colorScheme.primary,
                  unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  tabs: const [
                    Tab(text: 'Artwork'),
                    Tab(text: 'Lyrics'),
                    Tab(text: 'Visual'),
                  ],
                ),

                // Tab View
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(cardMargin),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(cardRadius),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(cardRadius),
                      child: TabBarView(
                        children: [
                          // Artwork Tab
                          Hero(
                            tag: 'artwork',
                            child: QueryArtworkWidget(
                              id: id, // Replace with actual song id
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: Container(
                                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                child: Icon(
                                  Icons.music_note_rounded,
                                  size: constraints.maxWidth * 0.25,
                                  color: theme.colorScheme.primary.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                          ),

                          Container(
                            color: theme.colorScheme.surface,
                            padding: const EdgeInsets.all(16),
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              children: [
                                Text(
                                  'Lyrics',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Your lyrics here...\n\n'
                                      'Line 1\n'
                                      'Line 2\n'
                                      'Line 3\n',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    height: 2,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          // Visual Tab (Lottie)
                          Container(
                            color: theme.colorScheme.surface,
                            child: Lottie.asset(
                              'assets/animations/music_visualization.json',
                              fit: BoxFit.cover,
                              repeat: true,
                              animate: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}
