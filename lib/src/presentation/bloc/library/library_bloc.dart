import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc() : super(LibraryState()) {
    on<LoadLibraryContent>(_onLoadLibraryContent);
    on<ChangeLibraryTab>(_onChangeLibraryTab);
  }

  Future<void> _onLoadLibraryContent(
      LoadLibraryContent event,
      Emitter<LibraryState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));
    // Add your loading logic here
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(isLoading: false));
  }

  void _onChangeLibraryTab(
      ChangeLibraryTab event,
      Emitter<LibraryState> emit,
      ) {
    emit(state.copyWith(currentTab: event.index));
  }
}
