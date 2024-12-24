part of 'settings_bloc.dart';

@immutable
class SettingsState {
  final ThemeMode themeMode;
  final bool equalizerEnabled;
  final bool gaplessPlaybackEnabled;
  final bool notificationEnabled;

  const SettingsState({
    required this.themeMode,
    required this.equalizerEnabled,
    required this.gaplessPlaybackEnabled,
    required this.notificationEnabled,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    bool? equalizerEnabled,
    bool? gaplessPlaybackEnabled,
    bool? notificationEnabled,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      equalizerEnabled: equalizerEnabled ?? this.equalizerEnabled,
      gaplessPlaybackEnabled: gaplessPlaybackEnabled ?? this.gaplessPlaybackEnabled,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
    );
  }
}
