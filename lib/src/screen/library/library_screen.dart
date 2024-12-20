import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/src/screen/library/util/music_list.dart';
import 'package:music_player/src/screen/procces/not_found.dart';

import '../../util/snacbar/scaffold_messanger.dart';
import '../procces/error.dart';
import '../procces/loading.dart';
import 'bloc/library_bloc.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late final LibraryBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = LibraryBloc()..add(LibraryLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        body: BlocConsumer<LibraryBloc, LibraryState>(
          listener: (context, state) {
            if (state is LibraryErrorState ||
                state is LibraryNoPermissionState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  ScaffoldMessengerUtil.showErrorSnackBar(
                    context,
                    'state.message',
                  );
                }
              });
            }
          },
          builder: (context, state) {
            if (state is LibraryLoadingState) {
              return const Loading();
            } else if (state is LibraryLoadedState) {
              return MusicList(
                music: state.music,
                folders: state.folders.map((folder) => folder.path).toList(),
              );

            } else if (state is LibraryEmptyState) {
              return NotFound();
            } else if (state is LibraryErrorState) {
              return const CustomError();
            }  else {
              print('[WARNING]: Unknown state encountered: $state');
              return SizedBox();
            }
          },
        ),
      ),
    );
  }
}
