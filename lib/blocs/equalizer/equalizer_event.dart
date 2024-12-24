part of 'equalizer_bloc.dart';

@immutable
abstract class EqualizerEvent extends Equatable {
  const EqualizerEvent();

  @override
  List<Object?> get props => [];
}

class InitializeEqualizer extends EqualizerEvent {}

class UpdateBandGain extends EqualizerEvent {
  final int bandId;
  final double gain;

  const UpdateBandGain(this.bandId, this.gain);

  @override
  List<Object> get props => [bandId, gain];
}

class LoadPreset extends EqualizerEvent {
  final String presetName;
  const LoadPreset(this.presetName);

  @override
  List<Object> get props => [presetName];
}

class SavePreset extends EqualizerEvent {
  final String name;
  const SavePreset(this.name);

  @override
  List<Object> get props => [name];
}
