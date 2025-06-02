import '../../domain/entities/pomodoro_session.dart';
import '../../domain/repositories/audio_repository.dart';
import '../../domain/repositories/analytics_repository.dart';

class ToggleModeUseCase {
  const ToggleModeUseCase({
    required this.audioRepository,
    required this.analyticsRepository,
  });

  final AudioRepository audioRepository;
  final AnalyticsRepository analyticsRepository;

  Future<void> execute(PomodoroSession session) async {
    final fromMode = session.currentModeName;
    session.toggleMode();
    final toMode = session.currentModeName;
    
    await audioRepository.playNotificationSound();
    await analyticsRepository.logModeToggle(fromMode, toMode);
  }
}
