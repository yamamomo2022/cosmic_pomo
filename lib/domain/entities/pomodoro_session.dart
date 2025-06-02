import '../../enum/pomodoro_mode.dart';
import '../value_objects/duration.dart';
import 'timer.dart' as domain_timer;

class PomodoroSession {
  PomodoroSession({
    PomodoroMode? initialMode,
    Duration? workDuration,
    Duration? breakDuration,
  }) : _currentMode = initialMode ?? PomodoroMode.workMode,
       _workDuration = workDuration ?? Duration.fromMinutes(25),
       _breakDuration = breakDuration ?? Duration.fromMinutes(3) {
    _currentTimer = _createTimerForCurrentMode();
  }

  PomodoroMode _currentMode;
  final Duration _workDuration;
  final Duration _breakDuration;
  domain_timer.Timer _currentTimer;

  PomodoroMode get currentMode => _currentMode;
  domain_timer.Timer get currentTimer => _currentTimer;
  Duration get workDuration => _workDuration;
  Duration get breakDuration => _breakDuration;

  String get currentModeName => _currentMode == PomodoroMode.workMode ? 'Work' : 'Break';

  Duration get currentDuration => _currentMode == PomodoroMode.workMode ? _workDuration : _breakDuration;

  void toggleMode() {
    _currentMode = _currentMode == PomodoroMode.workMode 
        ? PomodoroMode.breakMode 
        : PomodoroMode.workMode;
    _currentTimer = _createTimerForCurrentMode();
  }

  domain_timer.Timer _createTimerForCurrentMode() {
    return domain_timer.Timer(
      mode: _currentMode,
      duration: currentDuration,
    );
  }

  void resetCurrentTimer() {
    _currentTimer = _createTimerForCurrentMode();
  }

  void setCurrentTimer(domain_timer.Timer timer) {
    _currentTimer = timer;
  }
}
