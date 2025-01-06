part of 'settings_bloc.dart';

@immutable
class SettingsState extends Equatable {
  final String language;
  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final bool biometricsEnabled;

  const SettingsState({
    this.language = 'uz',
    this.themeMode = ThemeMode.system,
    this.notificationsEnabled = true,
    this.biometricsEnabled = false,
  });

  SettingsState copyWith({
    String? language,
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? biometricsEnabled,
  }) {
    return SettingsState(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
    );
  }

  @override
  List<Object> get props => [
    language,
    themeMode,
    notificationsEnabled,
    biometricsEnabled
  ];
}