import '../../domain/entities/pomodoro_session.dart';
import '../../domain/repositories/wakelock_repository.dart';

class StopTimerUseCase {
  const StopTimerUseCase({
    required this.wakelockRepository,
  });

  final WakelockRepository wakelockRepository;

  Future<void> execute(PomodoroSession session) async {
    session.currentTimer.stop();
    await wakelockRepository.disable();
  }
}
