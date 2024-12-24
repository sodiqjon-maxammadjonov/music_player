import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _themeKey = 'theme_mode';
  static const String _equalizerEnabledKey = 'equalizer_enabled';
  static const String _gaplessPlaybackKey = 'gapless_playback';
  static const String _showNotificationKey = 'show_notification';

  final SharedPreferences _prefs;

  SettingsService(this._prefs);

  static Future<SettingsService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsService(prefs);
  }

  ThemeMode getThemeMode() {
    final value = _prefs.getString(_themeKey);
    return ThemeMode.values.firstWhere(
          (mode) => mode.toString() == value,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeKey, mode.toString());
  }

  bool isEqualizerEnabled() {
    return _prefs.getBool(_equalizerEnabledKey) ?? true;
  }

  Future<void> setEqualizerEnabled(bool enabled) async {
    await _prefs.setBool(_equalizerEnabledKey, enabled);
  }

  bool isGaplessPlaybackEnabled() {
    return _prefs.getBool(_gaplessPlaybackKey) ?? true;
  }

  Future<void> setGaplessPlaybackEnabled(bool enabled) async {
    await _prefs.setBool(_gaplessPlaybackKey, enabled);
  }

  bool isNotificationEnabled() {
    return _prefs.getBool(_showNotificationKey) ?? true;
  }

  Future<void> setNotificationEnabled(bool enabled) async {
    await _prefs.setBool(_showNotificationKey, enabled);
  }
}
