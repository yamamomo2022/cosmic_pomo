import 'dart:async';
import 'dart:math' show pi, cos, sin, atan2;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmic Pomo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Cosmic Pomo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  // Constants for the Pomodoro timer
  static const int kPomodoroDuration = 25 * 60; // 25 minutes

  // Celestial body properties
  static const double kOrbitRadius = 80.0;
  static const double kCenterPoint = 100.0;
  static const double kCelestialBodySize = 30.0;
  static const Color kSunColor = Colors.red;
  static const Color kPlanetColor = Colors.blue;
  static const Color kOrbitColor = Colors.grey;

  int _remainingTime = kPomodoroDuration;
  Timer? _timer;

  // Animation controller for circular motion
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller with the total timer duration
    _animationController = AnimationController(
      duration: const Duration(seconds: kPomodoroDuration),
      vsync: this,
    );

    // Animation that moves in the opposite direction of the timer
    // (as timer decreases, planet moves forward)
    _animation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    // Variables needed for syncing the timer and animation
    final totalDuration = kPomodoroDuration.toDouble();
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
        }
      });
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    // Stop animation as well
    _animationController.stop();
  }

  void _resetTimer() {
    setState(() {
      _remainingTime = kPomodoroDuration;
      if (_timer != null) {
        _timer!.cancel();
      }
      // Reset animation
      _animationController.value = 0.0;
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _updateTimerFromPlanetPosition(double newAngle) {
    // Calculate normalized progress value (0.0 to 1.0)
    final double progressValue = newAngle / (2 * pi);

    setState(() {
      // Update animation controller
      _animationController.value = progressValue;

      // Update timer based on new position
      final int newRemainingTime =
          (kPomodoroDuration * (1.0 - progressValue)).round();
      _remainingTime = newRemainingTime;

      // Stop existing timer
      if (_timer != null) {
        _timer!.cancel();
        _timer = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              'Pomodoro Timer',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              _formatTime(_remainingTime),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            _buildOrbitalAnimation(),
            const SizedBox(height: 20),
            _buildTimerControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrbitalAnimation() {
    return SizedBox(
      height: 200,
      width: 200,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // Calculate planet position - subtract pi/2 to start from top position
          final double planetAngle = _animation.value - (pi / 2);
          final planetPosition = _calculatePlanetPosition(planetAngle);

          return Stack(
            children: [
              _buildOrbitPath(),
              _buildSun(),
              _buildDraggablePlanet(planetPosition),
            ],
          );
        },
      ),
    );
  }

  Map<String, double> _calculatePlanetPosition(double angle) {
    const double celestialBodyRadius = kCelestialBodySize / 2;

    final double x = kCenterPoint + kOrbitRadius * cos(angle);
    final double y = kCenterPoint + kOrbitRadius * sin(angle);

    return {'x': x, 'y': y, 'radius': celestialBodyRadius};
  }

  Widget _buildOrbitPath() {
    return Center(
      child: Container(
        width: kOrbitRadius * 2,
        height: kOrbitRadius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: kOrbitColor.withOpacity(0.3), width: 2),
        ),
      ),
    );
  }

  Widget _buildSun() {
    const double celestialBodyRadius = kCelestialBodySize / 2;

    return Positioned(
      left: kCenterPoint - celestialBodyRadius,
      top: kCenterPoint - celestialBodyRadius,
      child: Container(
        width: kCelestialBodySize,
        height: kCelestialBodySize,
        decoration: const BoxDecoration(
          color: kSunColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildDraggablePlanet(Map<String, double> position) {
    return Positioned(
      left: position['x']! - position['radius']!,
      top: position['y']! - position['radius']!,
      child: GestureDetector(
        onPanUpdate: (details) {
          _handlePlanetDrag(details, position);
        },
        child: Container(
          width: kCelestialBodySize,
          height: kCelestialBodySize,
          decoration: const BoxDecoration(
            color: kPlanetColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  void _handlePlanetDrag(
    DragUpdateDetails details,
    Map<String, double> position,
  ) {
    // Calculate drag position relative to orbit center
    final double dragX =
        details.localPosition.dx +
        position['x']! -
        position['radius']! -
        kCenterPoint;
    final double dragY =
        details.localPosition.dy +
        position['y']! -
        position['radius']! -
        kCenterPoint;

    // Calculate angle from drag position
    double newAngle = atan2(dragY, dragX) + (pi / 2);
    if (newAngle < 0) newAngle += 2 * pi;

    _updateTimerFromPlanetPosition(newAngle);
  }

  Widget _buildTimerControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: _startTimer, child: const Text('Start')),
        const SizedBox(width: 10),
        ElevatedButton(onPressed: _stopTimer, child: const Text('Stop')),
        const SizedBox(width: 10),
        ElevatedButton(onPressed: _resetTimer, child: const Text('Reset')),
      ],
    );
  }
}
