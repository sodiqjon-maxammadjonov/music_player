part of 'equalizer_bloc.dart';

@immutable
abstract class EqualizerState extends Equatable {
  const EqualizerState();

  @override
  List<Object?> get props => [];
}

class EqualizerInitial extends EqualizerState {}

class EqualizerReady extends EqualizerState {
  final List<EqualizerBand> bands;
  final Map<String, List<double>> presets;
  final String? currentPreset;

  const EqualizerReady({
    required this.bands,
    required this.presets,
    this.currentPreset,
  });

  @override
  List<Object?> get props => [bands, presets, currentPreset];
}
