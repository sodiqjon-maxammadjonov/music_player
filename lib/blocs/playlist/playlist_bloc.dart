import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../models/playlist.dart';
import '../../services/database_service.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final DatabaseService _databaseService;

  PlaylistBloc(this._databaseService) : super(PlaylistInitial()) {
    on<LoadPlaylists>(_onLoadPlaylists);
    on<CreatePlaylist>(_onCreatePlaylist);
    on<UpdatePlaylist>(_onUpdatePlaylist);
    on<DeletePlaylist>(_onDeletePlaylist);
    on<AddToPlaylist>(_onAddToPlaylist);
    on<RemoveFromPlaylist>(_onRemoveFromPlaylist);
  }

  Future<void> _onLoadPlaylists(LoadPlaylists event, Emitter<PlaylistState> emit) async {
    try {
      emit(PlaylistLoading());
      final playlists = await _databaseService.getAllPlaylists();
      emit(PlaylistsLoaded(playlists));
    } catch (e) {
      emit(PlaylistError('Failed to load playlists: $e'));
    }
  }

  Future<void> _onCreatePlaylist(CreatePlaylist event, Emitter<PlaylistState> emit) async {
    try {
      final playlist = Playlist(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.name,
        description: event.description,
        songIds: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _databaseService.insertPlaylist(playlist);
      add(LoadPlaylists());
    } catch (e) {
      emit(PlaylistError('Failed to create playlist: $e'));
    }
  }

  Future<void> _onUpdatePlaylist(UpdatePlaylist event, Emitter<PlaylistState> emit) async {
    try {
      final updatedPlaylist = event.playlist.copyWith(
        updatedAt: DateTime.now(),
      );
      await _databaseService.insertPlaylist(updatedPlaylist);
      add(LoadPlaylists());
    } catch (e) {
      emit(PlaylistError('Failed to update playlist: $e'));
    }
  }

  Future<void> _onDeletePlaylist(DeletePlaylist event, Emitter<PlaylistState> emit) async {
    try {
      await _databaseService.deletePlaylist(event.playlistId);
      add(LoadPlaylists());
    } catch (e) {
      emit(PlaylistError('Failed to delete playlist: $e'));
    }
  }

  Future<void> _onAddToPlaylist(AddToPlaylist event, Emitter<PlaylistState> emit) async {
    try {
      final playlist = await _databaseService.getPlaylist(event.playlistId);
      if (playlist != null) {
        final updatedPlaylist = playlist.copyWith(
          songIds: [...playlist.songIds, event.songId],
          updatedAt: DateTime.now(),
        );
        await _databaseService.insertPlaylist(updatedPlaylist);
        add(LoadPlaylists());
      }
    } catch (e) {
      emit(PlaylistError('Failed to add song to playlist: $e'));
    }
  }

  Future<void> _onRemoveFromPlaylist(RemoveFromPlaylist event, Emitter<PlaylistState> emit) async {
    try {
      final playlist = await _databaseService.getPlaylist(event.playlistId);
      if (playlist != null) {
        final updatedPlaylist = playlist.copyWith(
          songIds: playlist.songIds.where((id) => id != event.songId).toList(),
          updatedAt: DateTime.now(),
        );
        await _databaseService.insertPlaylist(updatedPlaylist);
        add(LoadPlaylists());
      }
    } catch (e) {
      emit(PlaylistError('Failed to remove song from playlist: $e'));
    }
  }
}