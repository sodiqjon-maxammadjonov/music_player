import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/src/presentation/widgets/music/music_list_widget.dart';
import '../../../../bloc/music/music_bloc.dart';

class MusicsTab extends StatefulWidget {
  const MusicsTab({super.key});

  @override
  State<MusicsTab> createState() => _MusicsTabState();
}

class _MusicsTabState extends State<MusicsTab> {
  final ScrollController _scrollController = ScrollController();
  late final MusicBloc _musicBloc;

  @override
  void initState() {
    super.initState();
    _musicBloc = MusicBloc()..add(LoadSongs());
  }

  Future<void> _handleRefresh() async {
    _musicBloc.add(LoadSongs());
    // Refresh indikatori ko'rinishi uchun minimal kutish vaqti
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _musicBloc.close();
    super.dispose();
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _handleRefresh,
            child: const Text('Qayta urinish'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 300),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.music_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Qo\'shiqlar topilmadi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Qurilmangizga qo\'shiq yuklang yoki pastga torting',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicList(List<dynamic> songs) {
    return Scrollbar(
      controller: _scrollController,
      thickness: 7.0,
      radius: const Radius.circular(10),
      interactive: true,
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: MusicListWidget(
                song: song,
                isPlaying: context.watch<MusicBloc>().state.currentSong?.id == song.id &&
                    context.watch<MusicBloc>().state.status == MusicPlayerStatus.playing,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _musicBloc,
      child: BlocBuilder<MusicBloc, MusicState>(
        builder: (context, state) {
          if (state.status == MusicPlayerStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status == MusicPlayerStatus.error) {
            return _buildErrorView(state.errorMessage ?? 'Xatolik yuz berdi');
          }

          if (state.songs.isEmpty) {
            return _buildEmptyView();
          }

          return _buildMusicList(state.songs);
        },
      ),
    );
  }
}