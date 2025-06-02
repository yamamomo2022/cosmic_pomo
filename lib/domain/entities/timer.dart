import '../value_objects/timer_state.dart';
import '../value_objects/duration.dart';
import '../../enum/pomodoro_mode.dart';

class Timer {
  Timer({
    required this.mode,
    required this.duration,
    TimerState? state,
    int? remainingTime,
    double? animationValue,
  }) : _state = state ?? TimerState.stopped,
       _remainingTime = remainingTime ?? duration.inSeconds,
       _animationValue = animationValue ?? 0.0;

  final PomodoroMode mode;
  final Duration duration;
  TimerState _state;
  int _remainingTime;
  double _animationValue;

  TimerState get state => _state;
  int get remainingTime => _remainingTime;
  double get animationValue => _animationValue;
  bool get isRunning => _state == TimerState.running;
  bool get isCompleted => _remainingTime <= 0;

  void start() {
    if (_state != TimerState.running) {
      _state = TimerState.running;
    }
  }

  void stop() {
    if (_state == TimerState.running) {
      _state = TimerState.stopped;
    }
  }

  void reset() {
    _state = TimerState.stopped;
    _remainingTime = duration.inSeconds;
    _animationValue = 0.0;
  }

  void tick() {
    if (_state == TimerState.running && _remainingTime > 0) {
      _remainingTime--;
      _animationValue = 1.0 - (_remainingTime / duration.inSeconds);
    }
    
    if (_remainingTime <= 0) {
      _state = TimerState.completed;
    }
  }

  void updateFromPosition(double newAngle, double fullCircle) {
    final double progressValue = newAngle / fullCircle;
    _animationValue = progressValue;
    _remainingTime = (duration.inSeconds * (1.0 - progressValue)).round();
    
    if (_state == TimerState.running) {
      _state = TimerState.stopped;
    }
  }

  Timer copyWith({
    PomodoroMode? mode,
    Duration? duration,
    TimerState? state,
    int? remainingTime,
    double? animationValue,
  }) {
    return Timer(
      mode: mode ?? this.mode,
      duration: duration ?? this.duration,
      state: state ?? _state,
      remainingTime: remainingTime ?? _remainingTime,
      animationValue: animationValue ?? _animationValue,
    );
  }
}
