import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/entities/pomodoro_session.dart';
import '../../infrastructure/repositories/audio_repository_impl.dart';
import '../../infrastructure/repositories/analytics_repository_impl.dart';
import '../../infrastructure/repositories/wakelock_repository_impl.dart';
import '../use_cases/start_timer_use_case.dart';
import '../use_cases/stop_timer_use_case.dart';
import '../use_cases/reset_timer_use_case.dart';
import '../use_cases/toggle_mode_use_case.dart';
import '../use_cases/update_timer_from_position_use_case.dart';
import '../use_cases/timer_tick_use_case.dart';
import '../services/pomodoro_timer_service.dart';

final audioRepositoryProvider = Provider((ref) => AudioRepositoryImpl());

final analyticsRepositoryProvider = Provider((ref) => AnalyticsRepositoryImpl());

final wakelockRepositoryProvider = Provider((ref) => WakelockRepositoryImpl());

final startTimerUseCaseProvider = Provider((ref) => StartTimerUseCase(
  wakelockRepository: ref.watch(wakelockRepositoryProvider),
  analyticsRepository: ref.watch(analyticsRepositoryProvider),
));

final stopTimerUseCaseProvider = Provider((ref) => StopTimerUseCase(
  wakelockRepository: ref.watch(wakelockRepositoryProvider),
));

final resetTimerUseCaseProvider = Provider((ref) => const ResetTimerUseCase());

final toggleModeUseCaseProvider = Provider((ref) => ToggleModeUseCase(
  audioRepository: ref.watch(audioRepositoryProvider),
  analyticsRepository: ref.watch(analyticsRepositoryProvider),
));

final updateTimerFromPositionUseCaseProvider = Provider((ref) => const UpdateTimerFromPositionUseCase());

final timerTickUseCaseProvider = Provider((ref) => TimerTickUseCase(
  audioRepository: ref.watch(audioRepositoryProvider),
  analyticsRepository: ref.watch(analyticsRepositoryProvider),
));

final pomodoroSessionProvider = StateNotifierProvider<PomodoroTimerService, PomodoroSession>((ref) {
  return PomodoroTimerService(
    startTimerUseCase: ref.watch(startTimerUseCaseProvider),
    stopTimerUseCase: ref.watch(stopTimerUseCaseProvider),
    resetTimerUseCase: ref.watch(resetTimerUseCaseProvider),
    toggleModeUseCase: ref.watch(toggleModeUseCaseProvider),
    updateTimerFromPositionUseCase: ref.watch(updateTimerFromPositionUseCaseProvider),
    timerTickUseCase: ref.watch(timerTickUseCaseProvider),
  );
});
