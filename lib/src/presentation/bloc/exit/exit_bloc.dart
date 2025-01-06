import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'exit_event.dart';
part 'exit_state.dart';

class ExitBloc extends Bloc<ExitEvent, ExitState> {
  Timer? _exitTimer;

  ExitBloc() : super(ExitState()) {
    on<ExitRequested>((event, emit) {
      final now = DateTime.now();
      final lastExitTime = state.lastExitTime;

      if (lastExitTime != null &&
          now.difference(lastExitTime).inSeconds <= 2) {
        emit(state.copyWith(canExit: true));
      } else {
        emit(state.copyWith(
          lastExitTime: now,
          canExit: false,
        ));

        _exitTimer?.cancel();
        _exitTimer = Timer(const Duration(seconds: 2), () {
          add(ExitTimerReset());
        });
      }
    });

    on<ExitTimerReset>((event, emit) {
      emit(state.copyWith(lastExitTime: null));
    });
  }

  @override
  Future<void> close() {
    _exitTimer?.cancel();
    return super.close();
  }
}
