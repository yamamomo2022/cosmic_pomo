import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/pomodoro_timer_service.dart';
import '../use_cases/start_timer_use_case.dart';
import '../use_cases/stop_timer_use_case.dart';
import '../use_cases/reset_timer_use_case.dart';
import '../use_cases/toggle_mode_use_case.dart';
import '../use_cases/update_timer_from_position_use_case.dart';
import '../use_cases/timer_tick_use_case.dart';
import '../../infrastructure/providers/infrastructure_providers.dart';

final startTimerUseCaseProvider = Provider<StartTimerUseCase>((ref) {
  return StartTimerUseCase(
    analyticsRepository: ref.read(analyticsRepositoryProvider),
    wakelockRepository: ref.read(wakelockRepositoryProvider),
  );
});

final stopTimerUseCaseProvider = Provider<StopTimerUseCase>((ref) {
  return StopTimerUseCase(
    wakelockRepository: ref.read(wakelockRepositoryProvider),
  );
});

final resetTimerUseCaseProvider = Provider<ResetTimerUseCase>((ref) {
  return const ResetTimerUseCase();
});

final toggleModeUseCaseProvider = Provider<ToggleModeUseCase>((ref) {
  return ToggleModeUseCase(
    analyticsRepository: ref.read(analyticsRepositoryProvider),
  );
});

final updateTimerFromPositionUseCaseProvider = Provider<UpdateTimerFromPositionUseCase>((ref) {
  return const UpdateTimerFromPositionUseCase();
});

final timerTickUseCaseProvider = Provider<TimerTickUseCase>((ref) {
  return TimerTickUseCase(
    audioRepository: ref.read(audioRepositoryProvider),
    analyticsRepository: ref.read(analyticsRepositoryProvider),
  );
});

final pomodoroTimerServiceProvider = StateNotifierProvider<PomodoroTimerService, PomodoroSession>((ref) {
  return PomodoroTimerService(
    startTimerUseCase: ref.read(startTimerUseCaseProvider),
    stopTimerUseCase: ref.read(stopTimerUseCaseProvider),
    resetTimerUseCase: ref.read(resetTimerUseCaseProvider),
    toggleModeUseCase: ref.read(toggleModeUseCaseProvider),
    updateTimerFromPositionUseCase: ref.read(updateTimerFromPositionUseCaseProvider),
    timerTickUseCase: ref.read(timerTickUseCaseProvider),
  );
});
