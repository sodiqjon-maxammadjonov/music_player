import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../library/library_screen.dart';
import 'bloc/main_screen_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late PageController pageController;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    pageController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainScreenBloc(),
      child: Scaffold(
        body: BlocBuilder<MainScreenBloc, MainScreenState>(
          builder: (context, state) {
            return GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  if (pageController.page! > 0) {
                    pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                } else if (details.primaryVelocity! < 0) {
                  if (pageController.page! < 2) {
                    pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                }
              },
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  context.read<MainScreenBloc>().add(MainScreenSwitchEvent(index: index));
                  tabController.animateTo(index);
                },
                children: [
                  HomeScreen(),
                  LibraryScreen(),
                  FavoritesScreen(),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((255 * 0.1).toInt()),
                blurRadius: 10,
                spreadRadius: 2,
              ),


            ],
          ),
          child: SafeArea(
            child: TabBar(
              controller: tabController,
              indicator: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3,
                  ),
                ),
              ),
              tabs: [
                _buildNavItem(
                  Icons.home_rounded,
                  'Home',
                  state is MainScreenHomeState || tabController.index == 0,
                ),
                _buildNavItem(
                  Icons.library_music_rounded,
                  'Library',
                  state is MainScreenLibraryState || tabController.index == 1,
                ),
                _buildNavItem(
                  Icons.favorite_rounded,
                  'Favorites',
                  state is MainScreenFavoriteState || tabController.index == 2,
                ),
              ],
              onTap: (index) {
                pageController.jumpToPage(index);
                context.read<MainScreenBloc>().add(MainScreenSwitchEvent(index: index));
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Tab(
      icon: Icon(
        icon,
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondary,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
          fontSize: 12,
        ),
      ),
    );
  }
}



class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player', style: Theme.of(context).textTheme.displayMedium),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_note_rounded,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Music App',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Tracks', style: Theme.of(context).textTheme.displayMedium),
      ),
      body: Center(
        child: Text(
          'Your Favorite Songs',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}