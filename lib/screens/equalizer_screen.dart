import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/equalizer/equalizer_bloc.dart';

class EqualizerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EqualizerBloc, EqualizerState>(
      builder: (context, state) {
        if (state is EqualizerReady) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Equalizer'),
              actions: [
                PopupMenuButton<String>(
                  itemBuilder: (context) => [
                    ...state.presets.keys.map((preset) => PopupMenuItem(
                      value: preset,
                      child: Text(preset),
                    )),
                    PopupMenuItem(
                      value: 'save',
                      child: Text('Save Current'),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'save') {
                      _showSavePresetDialog(context);
                    } else {
                      context.read<EqualizerBloc>().add(LoadPreset(value));
                    }
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                if (state.currentPreset != null)
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Current Preset: ${state.currentPreset}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: state.bands.map((band) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${band.gain.toStringAsFixed(1)} dB'),
                          RotatedBox(
                            quarterTurns: 3,
                            child: Slider(
                              value: band.gain,
                              min: band.minGain,
                              max: band.maxGain,
                              onChanged: (value) {
                                context.read<EqualizerBloc>().add(
                                  UpdateBandGain(band.id, value),
                                );
                              },
                            ),
                          ),
                          Text('${band.frequency} Hz'),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void _showSavePresetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SavePresetDialog(),
    );
  }
}