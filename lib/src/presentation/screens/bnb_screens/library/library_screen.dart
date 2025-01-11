import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:music_player/src/presentation/screens/bnb_screens/library/tab_screens/musics_tab.dart';
import '../../../bloc/library/library_bloc.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabAnimation);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabAnimation);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabAnimation() => setState(() {});
  void _handleTabChanged(int index) =>
      context.read<LibraryBloc>().add(ChangeLibraryTab(index));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final tabBarWidth = size.width * 0.95;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        title: Center(
          child: Container(
            height: 38,
            width: tabBarWidth,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              onTap: _handleTabChanged,
              dividerColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.15),
                    theme.colorScheme.secondary.withOpacity(0.15),
                  ],
                ),
              ),
              splashFactory: NoSplash.splashFactory,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              labelStyle: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: isSmallScreen ? 10 : 11,
                letterSpacing: 0,
              ),
              unselectedLabelStyle: theme.textTheme.labelSmall?.copyWith(
                fontSize: isSmallScreen ? 10 : 11,
                letterSpacing: 0,
              ),
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
              tabs: [
                _buildTab(l10n.musics, Icons.music_note_rounded, 0),
                _buildTab(l10n.albums, Icons.album_rounded, 1),
                _buildTab(l10n.favorites, Icons.favorite_rounded, 2),
                _buildTab(l10n.playlists, Icons.queue_music_rounded, 3),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MusicsTab(),
          _buildTabContent(l10n.about, theme),
          _buildTabContent(l10n.home, theme),
          _buildTabContent(l10n.home, theme),
        ],
      ),
    );
  }

  Widget _buildTab(String text, IconData icon, int index) {
    final isSelected = _tabController.index == index;
    final scale = isSelected ? 1.05 : 1.0;

    return Tab(
      height: 34,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: scale,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16),
              const SizedBox(width: 4),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(String text, ThemeData theme) {
    return Center(
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}