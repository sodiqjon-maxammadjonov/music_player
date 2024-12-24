import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_session/audio_session.dart';

import '../models/song.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();
  AndroidEqualizer? _equalizer;
  AudioPlayer get player => _player;

  AudioPlayerService() {
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    _equalizer = AndroidEqualizer();
    await _equalizer!.setEnabled(true);

    _player.playbackEventStream.listen(
          (event) {},
      onError: (Object e, StackTrace stackTrace) {
        print('A stream error occurred: $e');
      },
    );
  }

  Future<void> play(Song song) async {
    try {
      await _player.setAudioSource(
        AudioSource.file(
          song.path,
          tag: MediaItem(
            id: song.id,
            title: song.title,
            artist: song.artist,
            album: song.album,
            artUri: song.artwork != null ? Uri.parse(song.artwork!) : null,
          ),
        ),
      );
      await _player.play();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> playFromPlaylist(List<Song> songs, int initialIndex) async {
    try {
      final playlist = ConcatenatingAudioSource(
        children: songs.map((song) => AudioSource.file(
          song.path,
          tag: MediaItem(
            id: song.id,
            title: song.title,
            artist: song.artist,
            album: song.album,
            artUri: song.artwork != null ? Uri.parse(song.artwork!) : null,
          ),
        )).toList(),
      );

      await _player.setAudioSource(playlist, initialIndex: initialIndex);
      await _player.play();
    } catch (e) {
      print('Error playing playlist: $e');
    }
  }
  Future<void> setEqualizerBand(int bandId, double gain) async {
    if (_equalizer != null) {
      await _equalizer!.setEnabled(true);
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}