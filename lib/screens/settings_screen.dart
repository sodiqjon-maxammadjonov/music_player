import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildThemeSection(context),
          _buildPlaybackSection(context),
          _buildEqualizerSection(context),
          _buildAboutSection(context),
        ],
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('Theme'),
              subtitle: Text(state.themeMode.toString().split('.').last),
              onTap: () => _showThemeDialog(context),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlaybackSection(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text('Gapless Playback'),
              subtitle: Text('Seamless transition between songs'),
              value: state.gaplessPlaybackEnabled,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                  UpdateGaplessPlayback(value),
                );
              },
            ),
            SwitchListTile(
              title: Text('Show Notification'),
              subtitle: Text('Display playback controls in notification'),
              value: state.notificationEnabled,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                  UpdateNotification(value),
                );
              },
            ),
          ],
        );
      },
    );
  }
  Widget _buildEqualizerSection(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text('Equalizer'),
              subtitle: Text('Customize audio frequencies'),
              value: state.equalizerEnabled,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                  UpdateEqualizerEnabled(value),
                );
              },
            ),
            if (state.equalizerEnabled)
              ListTile(
                title: Text('Equalizer Settings'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.pushNamed(context, '/equalizer'),
              ),
          ],
        );
      },
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text('About'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () => Navigator.pushNamed(context, '/about'),
        ),
        ListTile(
          title: Text('Version'),
          subtitle: Text('1.0.0'),
        ),
      ],
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Choose Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ThemeMode.values.map((mode) {
              return RadioListTile<ThemeMode>(
                title: Text(mode.toString().split('.').last),
                value: mode,
                groupValue: context.read<SettingsBloc>().state.themeMode,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                    UpdateThemeMode(value!),
                  );
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }