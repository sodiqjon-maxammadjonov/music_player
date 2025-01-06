import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/const_values.dart';
import '../bloc/exit/exit_bloc.dart';
import '../bloc/navigation/navigation_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/snackbar/snackbar.dart';
import 'bnb_screens/home/home_screen.dart';
import 'bnb_screens/library/library_screen.dart';
import 'drawer/main_drawer.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return WillPopScope(
      onWillPop: () async {
        final exitBloc = context.read<ExitBloc>();
        exitBloc.add(ExitRequested());
        if (exitBloc.state.canExit) {
          SystemNavigator.pop();
          return true;
        }
        CustomSnackbar.show(
            context: context,
            message: l10n.exit_message,
            type: SnackbarType.info
        );
        return false;
      },
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
              ConstValues.appName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface
                ),
              ),
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu_rounded),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
            drawer: MainDrawer(),
            body: IndexedStack(
              index: state.currentTab.index,
              children: const [
                HomeScreen(),
                LibraryScreen(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.currentTab.index,
              onTap: (index) {
                context.read<NavigationBloc>().add(
                    TabChanged(NavigationTab.values[index])
                );
              },
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_rounded),
                  label: l10n.home,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.library_music_rounded),
                  label: l10n.library,
                ),
              ],
              type: BottomNavigationBarType.fixed,
            ),
          );
        },
      ),
    );
  }
}