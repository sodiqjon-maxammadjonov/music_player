part of 'exit_bloc.dart';

@immutable
class ExitState {
  final bool canExit;
  final DateTime? lastExitTime;

  ExitState({
    this.canExit = false,
    this.lastExitTime,
  });

  ExitState copyWith({
    bool? canExit,
    DateTime? lastExitTime,
  }) {
    return ExitState(
      canExit: canExit ?? this.canExit,
      lastExitTime: lastExitTime ?? this.lastExitTime,
    );
  }
}
