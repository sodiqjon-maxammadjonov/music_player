import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPreferences prefs;

  SettingsBloc({required this.prefs}) : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateLanguage>(_onUpdateLanguage);
    on<UpdateThemeMode>(_onUpdateThemeMode);
    on<UpdateNotifications>(_onUpdateNotifications);
    on<UpdateBiometrics>(_onUpdateBiometrics);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    final language = prefs.getString('language') ?? 'uz';
    final themeModeIndex = prefs.getInt('theme_mode') ?? 0;
    final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    final biometricsEnabled = prefs.getBool('biometrics_enabled') ?? false;

    emit(state.copyWith(
      language: language,
      themeMode: ThemeMode.values[themeModeIndex],
      notificationsEnabled: notificationsEnabled,
      biometricsEnabled: biometricsEnabled,
    ));
  }

  void _onUpdateLanguage(UpdateLanguage event, Emitter<SettingsState> emit) async {
    await prefs.setString('language', event.language);
    emit(state.copyWith(language: event.language));
  }

  void _onUpdateThemeMode(UpdateThemeMode event, Emitter<SettingsState> emit) async {
    await prefs.setInt('theme_mode', event.themeMode.index);
    emit(state.copyWith(themeMode: event.themeMode));
  }

  void _onUpdateNotifications(UpdateNotifications event, Emitter<SettingsState> emit) async {
    await prefs.setBool('notifications_enabled', event.enabled);
    emit(state.copyWith(notificationsEnabled: event.enabled));
  }

  void _onUpdateBiometrics(UpdateBiometrics event, Emitter<SettingsState> emit) async {
    await prefs.setBool('biometrics_enabled', event.enabled);
    emit(state.copyWith(biometricsEnabled: event.enabled));
  }
}
