part of 'library_bloc.dart';

@immutable
abstract class LibraryState extends Equatable {
  const LibraryState();

  @override
  List<Object?> get props => [];
}

class LibraryInitial extends LibraryState {}
class LibraryLoading extends LibraryState {}

class LibraryLoaded extends LibraryState {
  final List<Song> songs;
  final Map<String, List<Song>> albumSongs;
  final Map<String, List<Song>> artistSongs;

  const LibraryLoaded(this.songs, this.albumSongs, this.artistSongs);

  @override
  List<Object?> get props => [songs, albumSongs, artistSongs];
}

class LibraryError extends LibraryState {
  final String message;
  const LibraryError(this.message);

  @override
  List<Object> get props => [message];
}