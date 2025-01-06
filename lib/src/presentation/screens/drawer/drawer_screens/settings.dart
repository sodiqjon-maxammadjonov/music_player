import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/settings/settings_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart' show CupertinoSwitch;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.settings),
            elevation: 0,
            backgroundColor: colorScheme.surface,
            surfaceTintColor: Colors.transparent,
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              // Appearance Section
              _buildSectionHeader(context, l10n.appearance),
              const SizedBox(height: 8),
              _buildSettingsSection(
                icon: Icons.palette_rounded,
                title: l10n.theme,
                subtitle: _getThemeName(state.themeMode, context),
                onTap: () => _showThemeDialog(context),
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 8),
              _buildSettingsSection(
                icon: Icons.dark_mode_rounded,
                title: l10n.darkMode,
                subtitle: l10n.darkModeDescription,
                isSwitch: true,
                value: state.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                    UpdateThemeMode(
                      value ? ThemeMode.dark : ThemeMode.light,
                    ),
                  );
                },
                colorScheme: colorScheme,
              ),

              // Language Section
              const SizedBox(height: 24),
              _buildSectionHeader(context, l10n.language),
              const SizedBox(height: 8),
              _buildSettingsSection(
                icon: Icons.language_rounded,
                title: l10n.language,
                subtitle: _getLanguageName(state.language, context),
                onTap: () => _showLanguageDialog(context),
                colorScheme: colorScheme,
              ),

              // Notifications Section
              const SizedBox(height: 24),
              _buildSectionHeader(context, l10n.notifications),
              const SizedBox(height: 8),
              _buildSettingsSection(
                icon: Icons.notifications_rounded,
                title: l10n.notifications,
                subtitle: l10n.notificationsDescription,
                isSwitch: true,
                value: state.notificationsEnabled,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(UpdateNotifications(value));
                },
                colorScheme: colorScheme,
              ),

              // Security Section
              const SizedBox(height: 24),
              _buildSectionHeader(context, l10n.security),
              const SizedBox(height: 8),
              _buildSettingsSection(
                icon: Icons.fingerprint_rounded,
                title: l10n.biometricAuth,
                subtitle: l10n.biometricAuthDescription,
                isSwitch: true,
                value: state.biometricsEnabled,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(UpdateBiometrics(value));
                },
                colorScheme: colorScheme,
              ),

              // About Section
              const SizedBox(height: 24),
              _buildSectionHeader(context, l10n.about),
              const SizedBox(height: 8),
              _buildSettingsSection(
                icon: Icons.info_outline_rounded,
                title: l10n.appVersion,
                subtitle: '1.0.0',
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 8),
              _buildSettingsSection(
                icon: Icons.policy_rounded,
                title: l10n.privacyPolicy,
                onTap: () {
                  // Navigate to privacy policy
                },
                colorScheme: colorScheme,
                showDivider: true,
              ),
              _buildSettingsSection(
                icon: Icons.description_rounded,
                title: l10n.termsOfService,
                onTap: () {
                  // Navigate to terms of service
                },
                colorScheme: colorScheme,
                showDivider: true,
              ),
              _buildSettingsSection(
                icon: Icons.star_rounded,
                title: l10n.rateApp,
                subtitle: l10n.rateAppDescription,
                onTap: () {
                  // Open app store rating
                },
                colorScheme: colorScheme,
                showDivider: true,
              ),
              _buildSettingsSection(
                icon: Icons.share_rounded,
                title: l10n.shareApp,
                subtitle: l10n.shareAppDescription,
                onTap: () {
                  // Share app
                },
                colorScheme: colorScheme,
              ),
            ],
          ),
        );
      },
    );
  }

  // ... [Previous widget building methods remain the same]

  Widget _buildSettingsSection({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool isSwitch = false,
    bool value = false,
    ValueChanged<bool>? onChanged,
    required ColorScheme colorScheme,
    bool showDivider = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: colorScheme.outlineVariant,
                width: 0.5,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Icon(
                icon,
                color: colorScheme.primary,
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
              subtitle: subtitle != null
                  ? Text(
                subtitle,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
                  : null,
              trailing: isSwitch
                  ? Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: value,
                  onChanged: onChanged,
                  activeTrackColor: colorScheme.primary,
                ),
              )
                  : onTap != null
                  ? Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              )
                  : null,
              onTap: onTap,
            ),
          ),
        ),
        if (showDivider)
          const SizedBox(height: 8),
      ],
    );
  }
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return AlertDialog(
              title: Text(l10n.selectLanguage),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLanguageOption(
                    context: context,
                    title: l10n.uzbek,
                    subtitle: 'O\'zbek tili',
                    value: 'uz',
                    groupValue: state.language,
                    colorScheme: colorScheme,
                  ),
                  _buildLanguageOption(
                    context: context,
                    title: l10n.english,
                    subtitle: 'English',
                    value: 'en',
                    groupValue: state.language,
                    colorScheme: colorScheme,
                  ),
                  _buildLanguageOption(
                    context: context,
                    title: l10n.russian,
                    subtitle: 'Русский язык',
                    value: 'ru',
                    groupValue: state.language,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.cancel),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String value,
    required String groupValue,
    required ColorScheme colorScheme,
  }) {
    return RadioListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: colorScheme.onSurfaceVariant),
      ),
      value: value,
      groupValue: groupValue,
      onChanged: (value) {
        context.read<SettingsBloc>().add(UpdateLanguage(value!));
        Navigator.pop(context);
      },
      contentPadding: EdgeInsets.zero,
      activeColor: colorScheme.primary,
    );
  }

  void _showThemeDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return AlertDialog(
              title: Text(l10n.selectTheme),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildThemeOption(
                    context: context,
                    title: l10n.system,
                    subtitle: l10n.systemThemeDescription,
                    value: ThemeMode.system,
                    groupValue: state.themeMode,
                    colorScheme: colorScheme,
                    icon: Icons.brightness_auto,
                  ),
                  _buildThemeOption(
                    context: context,
                    title: l10n.light,
                    subtitle: l10n.lightThemeDescription,
                    value: ThemeMode.light,
                    groupValue: state.themeMode,
                    colorScheme: colorScheme,
                    icon: Icons.light_mode,
                  ),
                  _buildThemeOption(
                    context: context,
                    title: l10n.dark,
                    subtitle: l10n.darkThemeDescription,
                    value: ThemeMode.dark,
                    groupValue: state.themeMode,
                    colorScheme: colorScheme,
                    icon: Icons.dark_mode,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.cancel),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required ThemeMode value,
    required ThemeMode groupValue,
    required ColorScheme colorScheme,
    required IconData icon,
  }) {
    return RadioListTile(
      title: Row(
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: colorScheme.onSurfaceVariant),
      ),
      value: value,
      groupValue: groupValue,
      onChanged: (value) {
        context.read<SettingsBloc>().add(UpdateThemeMode(value!));
        Navigator.pop(context);
      },
      contentPadding: EdgeInsets.zero,
      activeColor: colorScheme.primary,
    );
  }

  String _getLanguageName(String languageCode, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (languageCode) {
      case 'uz':
        return l10n.uzbek;
      case 'en':
        return l10n.english;
      case 'ru':
        return l10n.russian;
      default:
        return l10n.uzbek;
    }
  }

  String _getThemeName(ThemeMode themeMode, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (themeMode) {
      case ThemeMode.system:
        return l10n.system;
      case ThemeMode.light:
        return l10n.light;
      case ThemeMode.dark:
        return l10n.dark;
    }
  }
}