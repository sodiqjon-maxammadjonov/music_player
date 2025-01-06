import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/constants/const_values.dart';
import 'drawer_screens/settings.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.primaryColor,
              gradient: LinearGradient(
                colors: [
                  theme.primaryColor,
                  theme.primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.music_note_rounded,
                  color: theme.colorScheme.onPrimary,
                  size: 60,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ConstValues.appName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'johndoe@example.com',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ListTile(
            leading: Icon(Icons.home_rounded,color: theme.colorScheme.onSurface),
            title: Text(l10n.home),
            onTap: () {
              Navigator.pop(context);
              // Add navigation logic if needed
            },
          ),
          ListTile(
            leading: Icon(Icons.library_music_rounded,color: theme.colorScheme.onSurface),
            title: Text(l10n.library),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.settings_rounded,color: theme.colorScheme.onSurface),
            title: Text(l10n.settings),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.star_rate_rounded,color: theme.colorScheme.onSurface),
            title: Text(l10n.rate_app),
            onTap: () async {
              final url = Uri.parse(
                'https://play.google.com/store/apps/details?id=example.app.package.name',
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.share_rounded,color: theme.colorScheme.onSurface),
            title: Text(l10n.share_app),
            onTap: () {
              Share.share(
                'Check out this amazing music app: https://play.google.com/store/apps/details?id=your.app.package.name',
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Version 1.0.0',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}