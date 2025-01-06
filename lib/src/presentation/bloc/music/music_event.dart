part of 'music_bloc.dart';

@immutable
abstract class MusicEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSongs extends MusicEvent {}

class PlaySong extends MusicEvent {
  final SongModel song;
  PlaySong(this.song);

  @override
  List<Object?> get props => [song];
}

class PauseSong extends MusicEvent {}

class ResumeSong extends MusicEvent {}

class DeleteSong extends MusicEvent {
  final SongModel song;
  DeleteSong(this.song);

  @override
  List<Object?> get props => [song];
}

class EditSong extends MusicEvent {
  final SongModel song;
  final String newTitle;
  final String newArtist;

  EditSong(this.song, {
    required this.newTitle,
    required this.newArtist,
  });

  @override
  List<Object?> get props => [song, newTitle, newArtist];
}

class UpdatePosition extends MusicEvent {
  final Duration position;
  UpdatePosition(this.position);

  @override
  List<Object?> get props => [position];
}
