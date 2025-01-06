part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class UpdateLanguage extends SettingsEvent {
  final String language;

  UpdateLanguage(this.language);

  @override
  List<Object> get props => [language];
}

class UpdateThemeMode extends SettingsEvent {
  final ThemeMode themeMode;

  UpdateThemeMode(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

class UpdateNotifications extends SettingsEvent {
  final bool enabled;

  UpdateNotifications(this.enabled);

  @override
  List<Object> get props => [enabled];
}

class UpdateBiometrics extends SettingsEvent {
  final bool enabled;

  UpdateBiometrics(this.enabled);

  @override
  List<Object> get props => [enabled];
}