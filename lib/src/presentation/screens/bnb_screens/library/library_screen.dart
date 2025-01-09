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

  void _handleTabAnimation() {
    setState(() {});
  }

  void _handleTabChanged(int index) {
    context.read<LibraryBloc>().add(ChangeLibraryTab(index));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              onTap: _handleTabChanged,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.2),
                    theme.colorScheme.secondary.withValues(alpha: 0.2),
                  ],
                ),
              ),
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              labelStyle: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
              unselectedLabelStyle: theme.textTheme.titleSmall,
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              tabs: [
                _buildAnimatedTab(l10n.musics, Icons.music_note_rounded, 0),
                _buildAnimatedTab(l10n.albums, Icons.album_rounded, 1),
                _buildAnimatedTab(l10n.favorites, Icons.favorite_rounded, 2),
                _buildAnimatedTab(l10n.playlists, Icons.queue_music_rounded, 3),
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

  Widget _buildAnimatedTab(String text, IconData icon, int index) {
    final isSelected = _tabController.index == index;
    final animationValue =
        (_tabController.animation?.value ?? 0) - index;
    final isAnimating = animationValue.abs() < 1;
    final scale = isAnimating
        ? 1.0 + (0.2 * (1 - (animationValue.abs())))
        : isSelected ? 1.2 : 1.0;

    return Tab(
      height: 40,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: scale,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
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
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}