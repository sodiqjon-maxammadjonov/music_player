import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/src/util/snacbar/scaffold_messanger.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

import '../../../bloc/library_bloc.dart';

class MusicActionsSheet extends StatefulWidget {
  final SongModel song;
  final VoidCallback? onActionComplete;
  final BuildContext parentContext;
  MusicActionsSheet({
    Key? key,
    required this.song,
    this.onActionComplete,
    required this.parentContext,
  }) : super(key: key);

  @override
  State<MusicActionsSheet> createState() => _MusicActionsSheetState();
}

class _MusicActionsSheetState extends State<MusicActionsSheet> {
  final OnAudioQuery audioQuery = OnAudioQuery();

  void _refreshLibrary() {
    BlocProvider.of<LibraryBloc>(widget.parentContext).add(LibraryLoadEvent());
    widget.onActionComplete?.call();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> shareSong(BuildContext context) async {
    try {
      final File songFile = File(widget.song.data);
      if (await songFile.exists()) {
        final xFile = XFile(widget.song.data);
        await Share.shareXFiles(
          [xFile],
          text: 'Listen to: ${widget.song.displayName}\nOwner: O\'zim',
          subject: widget.song.displayName,
        );
      } else {
        _showSnackBar(context, 'Music file not found');
      }
    } catch (e) {
      _showSnackBar(context, 'Error sharing file: $e');
    }
  }

  Future<void> deleteSong(BuildContext context) async {
    if (!await _checkStoragePermission(context)) return;

    try {
      if (await _showDeleteConfirmation(context)) {
        final File songFile = File(widget.song.data);
        if (await songFile.exists()) {
          await songFile.delete();
          _showSnackBar(context, 'Song deleted successfully');
          _refreshLibrary();
          if (mounted) {
            Navigator.pop(context);
          }
        } else {
          _showSnackBar(context, 'File not found');
        }
      }
    } catch (e) {
      _showSnackBar(context, 'Error: $e');
    }
  }

  Future<void> editSong(BuildContext context) async {
    try {
      final result = await _showEditDialog(context);
      if (result == true) {
        _refreshLibrary();
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      _showSnackBar(context, 'Error updating song details: $e');
    }
  }

  Future<bool> _checkStoragePermission(BuildContext context) async {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        ScaffoldMessengerUtil.showSnackBar(
            context,
            'Storage permission is required to delete files'
        );
        return false;
      }
    }
    return true;
  }

  void _showSnackBar(BuildContext context, String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete Song'),
        content: Text('Are you sure you want to delete "${widget.song.displayName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<bool?> _showEditDialog(BuildContext context) async {
    final titleController = TextEditingController(text: widget.song.title);
    final artistController = TextEditingController(text: widget.song.artist);
    final albumController = TextEditingController(text: widget.song.album);

    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Edit Song Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: artistController,
                decoration: const InputDecoration(labelText: 'Artist'),
              ),
              TextField(
                controller: albumController,
                decoration: const InputDecoration(labelText: 'Album'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == true) {
      final File songFile = File(widget.song.data);
      if (await songFile.exists()) {
        try {
          final String directory = songFile.parent.path;
          final String newPath = '$directory/${titleController.text}.mp3';

          await songFile.rename(newPath);

          /* TODO: Metadata yangilash qo'shish
          await audioQuery.updateMediaStore(
            songId: widget.song.id,
            title: titleController.text,
            artist: artistController.text,
            album: albumController.text,
          );
          */

          _showSnackBar(context, 'Song details updated successfully');
          return true;
        } catch (e) {
          _showSnackBar(context, 'Error updating file: $e');
          return false;
        }
      } else {
        _showSnackBar(context, 'Song file not found');
        return false;
      }
    }
    return false;
  }

  void _showSongInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Song Info'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Title: ${widget.song.title}'),
              Text('Artist: ${widget.song.artist ?? "Unknown"}'),
              Text('Album: ${widget.song.album ?? "Unknown"}'),
              Text('Duration: ${Duration(milliseconds: widget.song.duration ?? 0).toString().split('.').first}'),
              Text('Size: ${(File(widget.song.data).lengthSync() / 1024 / 1024).toStringAsFixed(2)} MB'),
              Text('Path: ${widget.song.data}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
      BuildContext context,
      String label,
      IconData icon,
      VoidCallback onPressed,
      ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _refreshLibrary();
        return true;
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Music Actions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 15),
            ListTile(
              leading: QueryArtworkWidget(
                id: widget.song.id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: Icon(
                    Icons.music_note_rounded,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
              title: Text(widget.song.displayName,maxLines: 2,),
              subtitle: Text('Artist: ${widget.song.artist ?? "Unknown"}',maxLines: 1,),
            ),
            const Divider(),
            _actionButton(
              context,
              'Edit Song',
              Icons.edit,
                  () => editSong(context),
            ),
            _actionButton(
              context,
              'Share Song',
              CupertinoIcons.share,
                  () async {
                await shareSong(context);
                Navigator.pop(context);
              },
            ),
            _actionButton(
              context,
              'Delete Song',
              CupertinoIcons.delete,
                  () => deleteSong(context),
            ),
            _actionButton(
              context,
              'View Info',
              CupertinoIcons.info_circle,
                  () => _showSongInfo(context),
            ),
          ],
        ),
      ),
    );
  }
}