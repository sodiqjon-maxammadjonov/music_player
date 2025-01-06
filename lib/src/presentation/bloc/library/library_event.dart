part of 'library_bloc.dart';

@immutable
sealed class LibraryEvent {}

class LoadLibraryContent extends LibraryEvent {}
class ChangeLibraryTab extends LibraryEvent {
  final int index;
  ChangeLibraryTab(this.index);
}
