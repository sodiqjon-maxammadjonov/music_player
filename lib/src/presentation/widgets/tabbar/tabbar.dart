import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomTabBar extends StatefulWidget {
  final TabController tabController;
  final Function(int) onTabChanged;

  const CustomTabBar({
    Key? key,
    required this.tabController,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    widget.tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (!widget.tabController.indexIsChanging) return;

    widget.onTabChanged(widget.tabController.index);
    _scrollToSelectedTab();
  }

  void _scrollToSelectedTab() {
    final RenderBox tabsBox = context.findRenderObject() as RenderBox;
    final double tabWidth = tabsBox.size.width / 4; // Approximate tab width
    final double screenWidth = MediaQuery.of(context).size.width;
    final double targetOffset = (widget.tabController.index * tabWidth) - (screenWidth / 2) + (tabWidth / 2);

    _scrollController.animateTo(
      targetOffset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            setState(() {
            });
          }
          return true;
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildTab(0, Icons.music_note_rounded, l10n.musics, theme),
              _buildTab(1, Icons.album_rounded, l10n.albums, theme),
              _buildTab(2, Icons.playlist_play_rounded, l10n.playlists, theme),
              _buildTab(3, Icons.favorite_rounded, l10n.favorites, theme),
              _buildTab(4, Icons.history_rounded, "History", theme),
              _buildTab(5, Icons.download_rounded, "Downloads", theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index, IconData icon, String label, ThemeData theme) {
    final isSelected = widget.tabController.index == index;

    return GestureDetector(
      onTap: () {
        widget.tabController.animateTo(index);
        widget.onTabChanged(index);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.6),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
