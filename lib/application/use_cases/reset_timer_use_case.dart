import '../../domain/entities/pomodoro_session.dart';

class ResetTimerUseCase {
  const ResetTimerUseCase();

  void execute(PomodoroSession session) {
    session.currentTimer.reset();
  }
}
