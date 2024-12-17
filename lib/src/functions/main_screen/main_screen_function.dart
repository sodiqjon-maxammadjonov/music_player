import 'package:bloc/bloc.dart';

import '../../screen/main/bloc/main_screen_bloc.dart';

class MainScreenFunction {
  static void emitState(int index, Emitter<MainScreenState> emit) {
    switch (index) {
      case 0:
        emit(MainScreenHomeState());
        break;
      case 1:
        emit(MainScreenLibraryState());
        break;
      case 2:
        emit(MainScreenFavoriteState());
        break;
      default:
        emit(MainScreenHomeState());
    }
  }
}