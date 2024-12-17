import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/src/screen/library/bloc/library_bloc.dart';
import 'package:music_player/src/screen/procces/error.dart';
import 'package:music_player/src/screen/procces/loading.dart';
import '../../util/snacbar/scaffold_messanger.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final bloc = LibraryBloc();
  @override
  void initState() {
    super.initState();
    bloc.add(LibraryLoadEvent());
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc..add(LibraryLoadEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Music Library',
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        body: BlocConsumer<LibraryBloc, LibraryState>(
          bloc: bloc,
          listenWhen: (previous, current) => current is LibraryActionsState,
          buildWhen: (previous, current) => current is! LibraryActionsState,
          listener: (context, state) {
            if (state is LibraryErrorState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  ScaffoldMessengerUtil.showErrorSnackBar(
                    context,
                    state.message,
                  );
                }
              });
            } else if (state is LibraryNoPermissionState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  ScaffoldMessengerUtil.showErrorSnackBar(
                    context,
                    state.message,
                  );
                }
              });
            }
          },
          builder: (context, state) {
            if (state is LibraryLoadingState) {
              return const Loading();
            } else if (state is LibraryLoadedState) {
              return ListView.builder(
                itemCount: state.music.length,
                itemBuilder: (context, index) {
                  final music = state.music[index];
                  return ListTile(
                    title: Text(music.toString()),
                  );
                },
              );
            } else if (state is LibraryEmptyState) {
              return Center(child: Text('No music found.'));
            } else {
              return const CustomError();
            }
          },
        ),
      ),
    );
  }
}
