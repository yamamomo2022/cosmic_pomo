import '../../domain/entities/pomodoro_session.dart';
import '../../domain/repositories/audio_repository.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../../domain/value_objects/timer_state.dart';

class TimerTickUseCase {
  const TimerTickUseCase({
    required this.audioRepository,
    required this.analyticsRepository,
  });

  final AudioRepository audioRepository;
  final AnalyticsRepository analyticsRepository;

  Future<bool> execute(PomodoroSession session) async {
    final wasCompleted = session.currentTimer.isCompleted;
    session.currentTimer.tick();
    
    if (!wasCompleted && session.currentTimer.isCompleted) {
      await audioRepository.playNotificationSound();
      await analyticsRepository.logTimerComplete(session.currentModeName);
      return true;
    }
    
    return false;
  }
}
