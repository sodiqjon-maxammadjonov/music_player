part of 'playlist_bloc.dart';

@immutable
abstract class PlaylistEvent extends Equatable {
  const PlaylistEvent();

  @override
  List<Object?> get props => [];
}

class LoadPlaylists extends PlaylistEvent {}

class CreatePlaylist extends PlaylistEvent {
  final String name;
  final String? description;

  const CreatePlaylist(this.name, {this.description});

  @override
  List<Object?> get props => [name, description];
}

class UpdatePlaylist extends PlaylistEvent {
  final Playlist playlist;
  const UpdatePlaylist(this.playlist);

  @override
  List<Object> get props => [playlist];
}

class DeletePlaylist extends PlaylistEvent {
  final String playlistId;
  const DeletePlaylist(this.playlistId);

  @override
  List<Object> get props => [playlistId];
}

class AddToPlaylist extends PlaylistEvent {
  final String playlistId;
  final String songId;

  const AddToPlaylist(this.playlistId, this.songId);

  @override
  List<Object> get props => [playlistId, songId];
}

class RemoveFromPlaylist extends PlaylistEvent {
  final String playlistId;
  final String songId;

  const RemoveFromPlaylist(this.playlistId, this.songId);

  @override
  List<Object> get props => [playlistId, songId];
}
