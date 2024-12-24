import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musiccccccc/screens/home_screen.dart';
import 'package:musiccccccc/services/audio_player_service.dart';
import 'package:musiccccccc/services/database_service.dart';
import 'package:musiccccccc/services/storage_service.dart';
import 'blocs/audio/audio_bloc.dart';
import 'blocs/library/library_bloc.dart';
import 'blocs/playlist/playlist_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.music_player.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  final databaseService = await DatabaseService.init();
  final storageService = await StorageService.init();
  final playerService = AudioPlayerService();

  runApp(MyApp(
    databaseService: databaseService,
    storageService: storageService,
    playerService: playerService,
  ));
}

class MyApp extends StatelessWidget {
  final DatabaseService databaseService;
  final StorageService storageService;
  final AudioPlayerService playerService;

  const MyApp({
    required this.databaseService,
    required this.storageService,
    required this.playerService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AudioBloc>(
          create: (context) => AudioBloc(playerService),
        ),
        BlocProvider<LibraryBloc>(
          create: (context) => LibraryBloc(
            databaseService,
            storageService,
          )..add(LoadLibrary()),
        ),
        BlocProvider<PlaylistBloc>(
          create: (context) => PlaylistBloc(databaseService),
        ),
        BlocProvider<FavoritesBloc>(
          create: (context) => FavoritesBloc(databaseService),
        ),
      ],
      child: MaterialApp(
        title: 'Music Player',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.grey[900],
        ),
        home: HomeScreen(),
      ),
    );
  }
}