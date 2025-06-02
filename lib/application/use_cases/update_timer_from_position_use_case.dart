import '../../domain/entities/pomodoro_session.dart';

class UpdateTimerFromPositionUseCase {
  const UpdateTimerFromPositionUseCase();

  void execute(PomodoroSession session, double newAngle, double fullCircle) {
    session.currentTimer.updateFromPosition(newAngle, fullCircle);
  }
}
