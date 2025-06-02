import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/entities/pomodoro_session.dart';
import '../../domain/entities/timer.dart' as domain_timer;
import '../../domain/value_objects/timer_state.dart';
import '../use_cases/start_timer_use_case.dart';
import '../use_cases/stop_timer_use_case.dart';
import '../use_cases/reset_timer_use_case.dart';
import '../use_cases/toggle_mode_use_case.dart';
import '../use_cases/update_timer_from_position_use_case.dart';
import '../use_cases/timer_tick_use_case.dart';

class PomodoroTimerService extends StateNotifier<PomodoroSession> {
  PomodoroTimerService({
    required this.startTimerUseCase,
    required this.stopTimerUseCase,
    required this.resetTimerUseCase,
    required this.toggleModeUseCase,
    required this.updateTimerFromPositionUseCase,
    required this.timerTickUseCase,
  }) : super(PomodoroSession());

  final StartTimerUseCase startTimerUseCase;
  final StopTimerUseCase stopTimerUseCase;
  final ResetTimerUseCase resetTimerUseCase;
  final ToggleModeUseCase toggleModeUseCase;
  final UpdateTimerFromPositionUseCase updateTimerFromPositionUseCase;
  final TimerTickUseCase timerTickUseCase;

  Timer? _timer;

  Future<void> startTimer() async {
    if (_timer != null) {
      _timer!.cancel();
    }

    await startTimerUseCase.execute(state);
    state = state.copyWith();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final wasCompleted = await timerTickUseCase.execute(state);
      state = state.copyWith();
      
      if (wasCompleted) {
        await toggleModeUseCase.execute(state);
        state = state.copyWith();
        await startTimerUseCase.execute(state);
        state = state.copyWith();
      }
    });
  }

  Future<void> stopTimer() async {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    
    await stopTimerUseCase.execute(state);
    state = state.copyWith();
  }

  void resetTimer() {
    resetTimerUseCase.execute(state);
    state = state.copyWith();
  }

  Future<void> toggleMode() async {
    await toggleModeUseCase.execute(state);
    state = state.copyWith();
  }

  void updateTimerFromPlanetPosition(double newAngle, double fullCircle) {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    
    updateTimerFromPositionUseCase.execute(state, newAngle, fullCircle);
    state = state.copyWith();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }
}

extension PomodoroSessionCopyWith on PomodoroSession {
  PomodoroSession copyWith() {
    final newSession = PomodoroSession(
      initialMode: currentMode,
      workDuration: workDuration,
      breakDuration: breakDuration,
    );
    newSession.setCurrentTimer(domain_timer.Timer(
      mode: currentTimer.mode,
      duration: currentTimer.duration,
      state: currentTimer.state,
      remainingTime: currentTimer.remainingTime,
      animationValue: currentTimer.animationValue,
    ));
    return newSession;
  }
}
