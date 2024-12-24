part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}

class LoadSettings extends SettingsEvent {}
class UpdateThemeMode extends SettingsEvent {
  final ThemeMode mode;
  UpdateThemeMode(this.mode);
}
class UpdateEqualizerEnabled extends SettingsEvent {
  final bool enabled;
  UpdateEqualizerEnabled(this.enabled);
}
class UpdateGaplessPlayback extends SettingsEvent {
  final bool enabled;
  UpdateGaplessPlayback(this.enabled);
}
class UpdateNotification extends SettingsEvent {
  final bool enabled;
  UpdateNotification(this.enabled);
}
