import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/theme/theme.dart';
import 'package:music_player/feutures/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'feutures/data/repositories/music_repository_impl.dart';
import 'feutures/domain/usecases/get_all_songs_usecase.dart';
import 'feutures/presentation/bloc/music/music_bloc.dart';
import 'feutures/presentation/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final audioQuery = OnAudioQuery();
  final prefs = await SharedPreferences.getInstance();
  final audioPlayer = AudioPlayer();

  final repository = MusicRepositoryImpl(
    audioQuery: audioQuery,
    prefs: prefs,
  );

  final getAllSongsUseCase = GetAllSongsUseCase(repository);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MusicBloc(
            getAllSongs: getAllSongsUseCase,
            repository: repository,
            audioPlayer: audioPlayer,
          )..add(LoadSongsEvent()),
        ),
        BlocProvider(create: (context) => NavigationBloc())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        title: 'Music Player',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        home: MainScreen(),
      ),
    ),
  );
}