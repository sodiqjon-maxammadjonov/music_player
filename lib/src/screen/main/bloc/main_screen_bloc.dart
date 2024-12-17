import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:music_player/src/functions/main_screen/main_screen_function.dart';
part 'main_screen_event.dart';
part 'main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  MainScreenBloc() : super(MainScreenInitial()) {
    on<MainScreenSwitchEvent>(onSwitch);
  }
  void onSwitch(MainScreenSwitchEvent event, Emitter<MainScreenState> emit) {
    MainScreenFunction.emitState(event.index, emit);
  }
}