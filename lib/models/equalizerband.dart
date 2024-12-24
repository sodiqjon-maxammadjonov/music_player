class EqualizerBand {
  final int id;
  final double frequency;
  final double gain;
  final double minGain;
  final double maxGain;

  EqualizerBand({
    required this.id,
    required this.frequency,
    this.gain = 0.0,
    this.minGain = -15.0,
    this.maxGain = 15.0,
  });

  EqualizerBand copyWith({double? gain}) {
    return EqualizerBand(
      id: id,
      frequency: frequency,
      gain: gain ?? this.gain,
      minGain: minGain,
      maxGain: maxGain,
    );
  }
}