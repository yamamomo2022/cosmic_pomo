import 'dart:async';

import 'package:cosmic_pomo/constants/app_constants.dart';
import 'package:cosmic_pomo/enum/pomodoro_mode.dart';
import 'package:cosmic_pomo/utils/time_formatter.dart';
import 'package:cosmic_pomo/widgets/orbital_animation.dart';
import 'package:cosmic_pomo/widgets/timer_controls.dart';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen>
    with SingleTickerProviderStateMixin {
  // Current mode of the timer
  PomodoroMode _currentMode = PomodoroMode.workMode;
  int _remainingTime = AppConstants.pomodoroDuration;
  Timer? _timer;

  // Animation controller for circular motion
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller with the total timer duration
    _animationController = AnimationController(
      duration: Duration(seconds: _getCurrentModeDuration()),
      vsync: this,
    );

    // Animation that moves in the opposite direction of the timer
    _animation = Tween<double>(
      begin: 0,
      end: AppConstants.fullCircle,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  /// Returns the duration in seconds for the current mode
  int _getCurrentModeDuration() {
    return _currentMode == PomodoroMode.workMode
        ? AppConstants.pomodoroDuration
        : AppConstants.breakDuration;
  }

  /// Returns a user-friendly name for the current mode
  String _getCurrentModeName() {
    return _currentMode == PomodoroMode.workMode ? 'Work' : 'Break';
  }

  /// Toggles between work and break modes
  void _toggleMode() {
    setState(() {
      _currentMode =
          _currentMode == PomodoroMode.workMode
              ? PomodoroMode.breakMode
              : PomodoroMode.workMode;

      // Reset timer for the new mode
      _remainingTime = _getCurrentModeDuration();

      // Reset animation controller duration
      _animationController.duration = Duration(
        seconds: _getCurrentModeDuration(),
      );
      _animationController.value = 0.0;
    });
  }

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    // タイマー開始時にウェイクロックを有効化
    WakelockPlus.enable();

    // Variables needed for syncing the timer and animation
    final totalDuration = _getCurrentModeDuration().toDouble();
    final currentProgress = _remainingTime / totalDuration;

    // Start animation from current timer position
    _animationController.value = 1.0 - currentProgress;

    // Timer progresses and animation moves accordingly
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
          // Update animation position based on timer progress
          _animationController.value = 1.0 - (_remainingTime / totalDuration);
        } else {
          _timer!.cancel();
          // Automatically switch to the next mode when timer completes
          _toggleMode();
          // Start the next timer automatically
          _startTimer();
        }
      });
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _animationController.stop();

    // タイマー停止時にウェイクロックを無効化
    WakelockPlus.disable();
  }

  void _resetTimer() {
    setState(() {
      _remainingTime = _getCurrentModeDuration();
      if (_timer != null) {
        _timer!.cancel();
      }
      _animationController.value = 0.0;
    });
  }

  void _updateTimerFromPlanetPosition(double newAngle) {
    // Calculate normalized progress value (0.0 to 1.0)
    final double progressValue = newAngle / AppConstants.fullCircle;

    setState(() {
      _animationController.value = progressValue;

      // Update timer based on new position
      final int newRemainingTime =
          (_getCurrentModeDuration() * (1.0 - progressValue)).round();
      _remainingTime = newRemainingTime;

      if (_timer != null) {
        _timer!.cancel();
        _timer = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color modeColor =
        _currentMode == PomodoroMode.workMode
            ? AppConstants.planetColor
            : AppConstants.breakModePlanetColor;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0B0D21), // Deep space blue
              Color(0xFF191970), // Midnight blue
              Color(0xFF000000), // Black
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: AppConstants.standardSpacing / 2),
              Text(
                '${_getCurrentModeName()} Mode',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: modeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Pomodoro Timer',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: Colors.white),
              ),
              Text(
                TimeFormatter.formatTime(_remainingTime),
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: AppConstants.standardSpacing),
              OrbitalAnimation(
                animation: _animation,
                onPlanetDragged: _updateTimerFromPlanetPosition,
                planetColor: modeColor,
              ),
              const SizedBox(height: AppConstants.standardSpacing),
              TimerControls(
                onStart: _startTimer,
                onStop: _stopTimer,
                onReset: _resetTimer,
              ),
              TextButton(
                onPressed: () {
                  _stopTimer();
                  _toggleMode();
                  _resetTimer();
                },
                child: Text(
                  'Switch to ${_currentMode == PomodoroMode.workMode ? 'Break Mode' : 'Work'} Mode',
                  style: TextStyle(color: modeColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
