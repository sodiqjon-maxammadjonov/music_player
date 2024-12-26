// lib/presentation/screens/library/tab_screens/musics_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/music_list_widget.dart';
import '../../../bloc/music/music_bloc.dart';

class MusicsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicBloc, MusicState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state.error != null) {
          return Center(child: Text(state.error!));
        }
        return Scaffold(
          body: MusicListWidget(songs: state.songs),
        );
      },
    );
  }
}
