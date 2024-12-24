import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/equalizerband.dart';
import '../../services/audio_player_service.dart';

part 'equalizer_event.dart';
part 'equalizer_state.dart';

class EqualizerBloc extends Bloc<EqualizerEvent, EqualizerState> {
  final AudioPlayerService _playerService;

  EqualizerBloc(this._playerService) : super(EqualizerInitial()) {
    on<InitializeEqualizer>(_onInitializeEqualizer);
    on<UpdateBandGain>(_onUpdateBandGain);
    on<LoadPreset>(_onLoadPreset);
    on<SavePreset>(_onSavePreset);
  }

  final List<EqualizerBand> _defaultBands = [
    EqualizerBand(id: 0, frequency: 60),    // Bass
    EqualizerBand(id: 1, frequency: 230),   // Bass Mid
    EqualizerBand(id: 2, frequency: 910),   // Mid
    EqualizerBand(id: 3, frequency: 3600),  // Upper Mid
    EqualizerBand(id: 4, frequency: 14000), // Treble
  ];

  final Map<String, List<double>> _defaultPresets = {
    'Flat': [0, 0, 0, 0, 0],
    'Rock': [4, 3, -2, 2, 3],
    'Pop': [-1, 2, 3, 2, -1],
    'Jazz': [3, 2, -1, 2, 3],
    'Classical': [3, 1, 0, 1, 2],
  };

  Future<void> _onInitializeEqualizer(
      InitializeEqualizer event,
      Emitter<EqualizerState> emit,
      ) async {
    emit(EqualizerReady(
      bands: _defaultBands,
      presets: _defaultPresets,
    ));
  }

  Future<void> _onUpdateBandGain(
      UpdateBandGain event,
      Emitter<EqualizerState> emit,
      ) async {
    if (state is EqualizerReady) {
      final currentState = state as EqualizerReady;
      final updatedBands = currentState.bands.map((band) {
        if (band.id == event.bandId) {
          return band.copyWith(gain: event.gain);
        }
        return band;
      }).toList();


      await _playerService.setEqualizerBand(event.bandId, event.gain);

      emit(EqualizerReady(
        bands: updatedBands,
        presets: currentState.presets,
        currentPreset: null, // Reset preset when manually adjusting
      ));
    }
  }

  Future<void> _onLoadPreset(
      LoadPreset event,
      Emitter<EqualizerState> emit,
      ) async {
    if (state is EqualizerReady) {
      final currentState = state as EqualizerReady;
      final preset = currentState.presets[event.presetName];

      if (preset != null) {
        final updatedBands = List<EqualizerBand>.from(currentState.bands);
        for (var i = 0; i < updatedBands.length; i++) {
          updatedBands[i] = updatedBands[i].copyWith(gain: preset[i]);
          await _playerService.setEqualizerBand(i, preset[i]);
        }

        emit(EqualizerReady(
          bands: updatedBands,
          presets: currentState.presets,
          currentPreset: event.presetName,
        ));
      }
    }
  }

  Future<void> _onSavePreset(
      SavePreset event,
      Emitter<EqualizerState> emit,
      ) async {
    if (state is EqualizerReady) {
      final currentState = state as EqualizerReady;
      final gains = currentState.bands.map((band) => band.gain).toList();

      final updatedPresets = Map<String, List<double>>.from(currentState.presets);
      updatedPresets[event.name] = gains;

      emit(EqualizerReady(
        bands: currentState.bands,
        presets: updatedPresets,
        currentPreset: event.name,
      ));
    }
  }
}
