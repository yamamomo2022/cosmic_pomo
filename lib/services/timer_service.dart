import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cosmic_pomo/constants/app_constants.dart';
import 'package:cosmic_pomo/enum/pomodoro_mode.dart';
import 'package:flutter/foundation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../utils/logger.dart';

class TimerService extends ChangeNotifier {
  // Current state variables
  PomodoroMode _currentMode = PomodoroMode.workMode;
  int _remainingTime = AppConstants.pomodoroDuration;
  Timer? _timer;
  bool _isRunning = false;
  double _animationValue = 0.0;

  // Getters
  PomodoroMode get currentMode => _currentMode;
  int get remainingTime => _remainingTime;
  bool get isRunning => _isRunning;
  double get animationValue => _animationValue;

  // AudioPlayerインスタンスを追加
  final AudioPlayer _audioPlayer = AudioPlayer();
  static const String _soundAssetPath =
      'audio/notification.mp3'; // 音声ファイルのパスを指定

  // Constructor
  TimerService() {
    _remainingTime = _getCurrentModeDuration();
  }

  /// Returns the duration in seconds for the current mode
  int _getCurrentModeDuration() {
    return _currentMode == PomodoroMode.workMode
        ? AppConstants.pomodoroDuration
        : AppConstants.breakDuration;
  }

  /// Returns a user-friendly name for the current mode
  String getCurrentModeName() {
    return _currentMode == PomodoroMode.workMode ? 'Work' : 'Break';
  }

  Future<void> _playSound() async {
    try {
      await _audioPlayer.play(AssetSource(_soundAssetPath));
      logger.d('Played sound: $_soundAssetPath');
    } catch (e) {
      logger.e('Error playing sound: $e');
    }
  }

  /// Toggles between work and break modes
  void toggleMode() {
    _currentMode =
        _currentMode == PomodoroMode.workMode
            ? PomodoroMode.breakMode
            : PomodoroMode.workMode;

    // Reset timer for the new mode
    _remainingTime = _getCurrentModeDuration();
    _animationValue = 0.0;

    // モード切り替え時に音を鳴らす
    _playSound();

    notifyListeners();
  }

  void startTimer() {
    logger.d('Timer started');
    if (_timer != null) {
      _timer!.cancel();
    }

    // Enable wakelock when timer starts
    WakelockPlus.enable();
    _isRunning = true;

    // Variables needed for syncing the timer and animation
    final totalDuration = _getCurrentModeDuration().toDouble();
    final currentProgress = _remainingTime / totalDuration;

    // Set animation value based on current timer position
    _animationValue = 1.0 - currentProgress;

    // Timer progresses and animation moves accordingly
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        // Update animation position based on timer progress
        _animationValue = 1.0 - (_remainingTime / totalDuration);
        notifyListeners();
      } else {
        _timer!.cancel();
        // タイマー完了時に音を鳴らす
        _playSound();
        // Automatically switch to the next mode when timer completes
        toggleMode();
        // Start the next timer automatically
        startTimer();
      }
    });

    notifyListeners();
  }

  void stopTimer() {
    logger.d('Timer stopped');
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    _isRunning = false;

    // Disable wakelock when timer stops
    WakelockPlus.disable();

    notifyListeners();
  }

  void resetTimer() {
    logger.d('Timer reset');
    _remainingTime = _getCurrentModeDuration();
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    _isRunning = false;
    _animationValue = 0.0;

    notifyListeners();
  }

  void updateTimerFromPlanetPosition(double newAngle) {
    // Calculate normalized progress value (0.0 to 1.0)
    final double progressValue = newAngle / AppConstants.fullCircle;
    _animationValue = progressValue;

    // Update timer based on new position
    final int newRemainingTime =
        (_getCurrentModeDuration() * (1.0 - progressValue)).round();
    _remainingTime = newRemainingTime;

    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
      _isRunning = false;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }
}
