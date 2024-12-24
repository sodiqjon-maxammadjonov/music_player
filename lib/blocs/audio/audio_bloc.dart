import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/song.dart';
import '../../services/audio_player_service.dart';

part 'audio_event.dart';
part 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioPlayerService _playerService;

  AudioBloc(this._playerService) : super(AudioInitial()) {
    on<PlaySong>(_onPlaySong);
    on<PauseSong>(_onPauseSong);
    on<ResumeSong>(_onResumeSong);
    on<StopSong>(_onStopSong);
    on<SeekAudio>(_onSeekAudio);

    // Listen to player state changes
    _playerService.player.playerStateStream.listen((playerState) {
      if (playerState.playing) {
        // Update state with current position
      }
    });
  }

  void _onPlaySong(PlaySong event, Emitter<AudioState> emit) async {
    if (event.playlist != null && event.playlistIndex != null) {
      await _playerService.playFromPlaylist(event.playlist!, event.playlistIndex!);
    } else {
      await _playerService.play(event.song);
    }

    emit(AudioPlaying(
      event.song,
      _playerService.player.duration ?? Duration.zero,
      _playerService.player.position,
      playlist: event.playlist,
      playlistIndex: event.playlistIndex,
    ));
  }
  void _onPauseSong(PauseSong event, Emitter<AudioState> emit) async {
    await _playerService.player.pause();
    if (state is AudioPlaying) {
      final playingState = state as AudioPlaying;
      emit(AudioPaused(playingState.song, _playerService.player.position));
    }
  }

  void _onResumeSong(ResumeSong event, Emitter<AudioState> emit) async {
    await _playerService.player.play();
    if (state is AudioPaused) {
      final pausedState = state as AudioPaused;
      emit(AudioPlaying(
        pausedState.song,
        _playerService.player.duration ?? Duration.zero,
        _playerService.player.position,
      ));
    }
  }

  void _onStopSong(StopSong event, Emitter<AudioState> emit) async {
    await _playerService.player.stop();
    emit(AudioStopped());
  }

  void _onSeekAudio(SeekAudio event, Emitter<AudioState> emit) async {
    await _playerService.player.seek(event.position);
    if (state is AudioPlaying) {
      final playingState = state as AudioPlaying;
      emit(AudioPlaying(
        playingState.song,
        _playerService.player.duration ?? Duration.zero,
        event.position,
        playlist: playingState.playlist,
        playlistIndex: playingState.playlistIndex,
      ));
    }
  }

  @override
  Future<void> close() {
    _playerService.dispose();
    return super.close();
  }
}
