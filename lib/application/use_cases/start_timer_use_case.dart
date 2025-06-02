import '../../domain/entities/pomodoro_session.dart';
import '../../domain/repositories/wakelock_repository.dart';
import '../../domain/repositories/analytics_repository.dart';

class StartTimerUseCase {
  const StartTimerUseCase({
    required this.wakelockRepository,
    required this.analyticsRepository,
  });

  final WakelockRepository wakelockRepository;
  final AnalyticsRepository analyticsRepository;

  Future<void> execute(PomodoroSession session) async {
    session.currentTimer.start();
    await wakelockRepository.enable();
    await analyticsRepository.logTimerStart(session.currentModeName);
  }
}
