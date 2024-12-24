import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../services/settings_service.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsService _settings;

  SettingsBloc(this._settings) : super(SettingsState(
    themeMode: ThemeMode.system,
    equalizerEnabled: true,
    gaplessPlaybackEnabled: true,
    notificationEnabled: true,
  )) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateThemeMode>(_onUpdateThemeMode);
    on<UpdateEqualizerEnabled>(_onUpdateEqualizerEnabled);
    on<UpdateGaplessPlayback>(_onUpdateGaplessPlayback);
    on<UpdateNotification>(_onUpdateNotification);
  }

  Future<void> _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(
      themeMode: _settings.getThemeMode(),
      equalizerEnabled: _settings.isEqualizerEnabled(),
      gaplessPlaybackEnabled: _settings.isGaplessPlaybackEnabled(),
      notificationEnabled: _settings.isNotificationEnabled(),
    ));
  }

  Future<void> _onUpdateThemeMode(UpdateThemeMode event, Emitter<SettingsState> emit) async {
    await _settings.setThemeMode(event.mode);
    emit(state.copyWith(themeMode: event.mode));
  }

  Future<void> _onUpdateEqualizerEnabled(UpdateEqualizerEnabled event, Emitter<SettingsState> emit) async {
    await _settings.setEqualizerEnabled(event.enabled);
    emit(state.copyWith(equalizerEnabled: event.enabled));
  }

  Future<void> _onUpdateGaplessPlayback(UpdateGaplessPlayback event, Emitter<SettingsState> emit) async {
    await _settings.setGaplessPlaybackEnabled(event.enabled);
    emit(state.copyWith(gaplessPlaybackEnabled: event.enabled));
  }

  Future<void> _onUpdateNotification(UpdateNotification event, Emitter<SettingsState> emit) async {
    await _settings.setNotificationEnabled(event.enabled);
    emit(state.copyWith(notificationEnabled: event.enabled));
  }
}