part of 'library_bloc.dart';

@immutable
abstract class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object?> get props => [];
}

class LoadLibrary extends LibraryEvent {}
class ImportSongs extends LibraryEvent {}
class RefreshLibrary extends LibraryEvent {}
class DeleteSong extends LibraryEvent {
  final Song song;
  const DeleteSong(this.song);

  @override
  List<Object> get props => [song];
}
