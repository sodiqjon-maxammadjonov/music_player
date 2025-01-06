part of 'exit_bloc.dart';

@immutable
sealed class ExitEvent {}

class ExitRequested extends ExitEvent {}
class ExitTimerReset extends ExitEvent {}
