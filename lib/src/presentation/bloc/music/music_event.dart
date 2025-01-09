part of 'music_bloc.dart';

@immutable
abstract class MusicEvent extends Equatable {
  const MusicEvent();

  @override
  List<Object?> get props => [];
}

class LoadSongs extends MusicEvent {
  const LoadSongs();
}

class PlaySong extends MusicEvent {
  final SongModel song;

  const PlaySong({required this.song});

  @override
  List<Object?> get props => [song];
}

class PauseSong extends MusicEvent {
  const PauseSong();
}

class ResumeSong extends MusicEvent {
  const ResumeSong();
}

class DeleteSong extends MusicEvent {
  final SongModel song;

  const DeleteSong({required this.song});

  @override
  List<Object?> get props => [song];
}

class UpdatePosition extends MusicEvent {
  final Duration position;
  final Duration duration;

  const UpdatePosition({
    required this.position,
    required this.duration,
  });

  @override
  List<Object?> get props => [position, duration];
}

class EditSong extends MusicEvent {
  final SongModel song;
  final String newTitle;

  const EditSong({
    required this.song,
    required this.newTitle,
  });

  @override
  List<Object?> get props => [song, newTitle];
}

class SeekTo extends MusicEvent {
  final Duration position;

  const SeekTo({required this.position});

  @override
  List<Object?> get props => [position];
}


class ShareSong extends MusicEvent {
  final SongModel song;

  const ShareSong({required this.song});

  @override
  List<Object?> get props => [song];
}