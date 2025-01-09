import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../../bloc/music/music_bloc.dart';

class MusicsTab extends StatefulWidget {
  const MusicsTab({super.key});

  @override
  State<MusicsTab> createState() => _MusicsTabState();
}

class _MusicsTabState extends State<MusicsTab> {
  final ScrollController _scrollController = ScrollController();
  final MusicBloc bloc = MusicBloc();

  String _formatDuration(int milliseconds) {
    final minutes = (milliseconds / 60000).floor();
    final seconds = ((milliseconds % 60000) / 1000).floor();
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _handleRefresh() async {
    bloc.add(LoadSongs());
    // Real refresh logic should wait for the songs to load
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MusicBloc()..add(LoadSongs()),
      child: BlocBuilder<MusicBloc, MusicState>(
        builder: (context, state) {
          if (state.status == MusicPlayerStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == MusicPlayerStatus.error) {
            return Center(child: Text(state.errorMessage ?? 'An error occurred'));
          }

          if (state.songs.isEmpty) {
            return RefreshIndicator(
              onRefresh: _handleRefresh,
              child: ListView(
                children: const [
                  SizedBox(height: 300), // To make sure refresh works even when empty
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.music_off, size: 64),
                        SizedBox(height: 16),
                        Text('No songs found'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Scrollbar(
              controller: _scrollController,
              thickness: 7.0,
              radius: const Radius.circular(10),
              interactive: true,
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: state.songs.length,
                  itemBuilder: (context, index) {
                    final song = state.songs[index];
                    final isPlaying = state.currentSong?.id == song.id &&
                        state.status == MusicPlayerStatus.playing;

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        leading: QueryArtworkWidget(
                          id: song.id,
                          type: ArtworkType.AUDIO,
                          keepOldArtwork: true,
                          artworkBorder: BorderRadius.circular(8),
                          nullArtworkWidget: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.music_note,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        title: Text(
                          song.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          song.artist ?? 'Unknown Artist',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_formatDuration(song.duration ?? 0)),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
                              ),
                              onPressed: () {
                                context.read<MusicBloc>().add(PlaySong(song: song));
                              },
                            ),
                            PopupMenuButton<String>(
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit),
                                      SizedBox(width: 8),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'share',
                                  child: Row(
                                    children: [
                                      Icon(Icons.share),
                                      SizedBox(width: 8),
                                      Text('Share'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete),
                                      SizedBox(width: 8),
                                      Text('Delete'),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) async {
                                switch (value) {
                                  case 'edit':
                                  // edit func here
                                    break;
                                  case 'share':
                                    await bloc..add(ShareSong(song: song));
                                    break;
                                  case 'delete':
                                    final shouldDelete = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Song'),
                                        content: Text('Are you sure you want to delete "${song.title}"?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (shouldDelete == true) {
                                      bloc.add(DeleteSong(song: song));
                                    }
                                    break;
                                }
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          if(isPlaying) {
                            bloc.add(PauseSong());
                          } else {
                            bloc.add(PlaySong(song: song));
                          }
                        },
                      ),
                    );
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