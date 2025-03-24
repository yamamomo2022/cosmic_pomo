import 'dart:async'; // Add this import for Timer
import 'dart:math'
    show pi, cos, sin, atan2; // Add this import for circular motion

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  static const int _pomodoroDuration = 1 * 60; // 25 minutes
  int _remainingTime = _pomodoroDuration;
  Timer? _timer;

  // Animation controller for circular motion
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // タイマーの総時間に合わせたアニメーションコントローラの初期化
    _animationController = AnimationController(
      duration: const Duration(seconds: _pomodoroDuration),
      vsync: this,
    );

    // タイマーと逆方向に動くアニメーション（タイマーが減るにつれて惑星は進む）
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

    // タイマーとアニメーションの同期に必要な変数
    final totalDuration = _pomodoroDuration.toDouble();
    final currentProgress = _remainingTime / totalDuration;

    // アニメーションを現在のタイマー位置から開始
    _animationController.value = 1.0 - currentProgress;

    // タイマーが減るにつれてアニメーションが進む
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
          // タイマーの進行に合わせてアニメーション位置を更新
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
    // アニメーションも停止
    _animationController.stop();
  }

  void _resetTimer() {
    setState(() {
      _remainingTime = _pomodoroDuration;
      if (_timer != null) {
        _timer!.cancel();
      }
      // アニメーションをリセット
      _animationController.value = 0.0;
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...existing code...
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
            // 円運動アニメーション
            SizedBox(
              height: 200,
              width: 200,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  // Orbital parameters with descriptive names
                  const double orbitRadius = 80.0;
                  const double centerX = 100.0;
                  const double centerY = 100.0;
                  const double celestialBodySize = 30.0;
                  const double celestialBodyRadius = celestialBodySize / 2;

                  // Calculate planet position - subtract pi/2 to start from top position
                  // When animation.value is 0, planet will be at 12 o'clock position
                  final double planetAngle = _animation.value - (pi / 2);
                  final double planetX =
                      centerX + orbitRadius * cos(planetAngle);
                  final double planetY =
                      centerY + orbitRadius * sin(planetAngle);

                  return Stack(
                    children: [
                      // Orbit path
                      Center(
                        child: Container(
                          width: orbitRadius * 2,
                          height: orbitRadius * 2,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      // Sun at the center of the orbit
                      Positioned(
                        left: centerX - celestialBodyRadius,
                        top: centerY - celestialBodyRadius,
                        child: Container(
                          width: celestialBodySize,
                          height: celestialBodySize,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      // Interactive planet orbiting around the sun
                      Positioned(
                        left: planetX - celestialBodyRadius,
                        top: planetY - celestialBodyRadius,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            // Calculate drag position relative to orbit center
                            final double dragX =
                                details.localPosition.dx +
                                planetX -
                                celestialBodyRadius -
                                centerX;
                            final double dragY =
                                details.localPosition.dy +
                                planetY -
                                celestialBodyRadius -
                                centerY;

                            // Calculate angle from drag position (atan2 gives angle in radians)
                            double newAngle = atan2(dragY, dragX) + (pi / 2);
                            if (newAngle < 0) newAngle += 2 * pi;

                            // Convert to normalized progress value (0.0 to 1.0)
                            final double progressValue = newAngle / (2 * pi);

                            // Update animation and timer
                            setState(() {
                              // Update animation controller
                              _animationController.value = progressValue;

                              // Update timer based on new position
                              final int newRemainingTime =
                                  (_pomodoroDuration * (1.0 - progressValue))
                                      .round();
                              _remainingTime = newRemainingTime;

                              // Stop existing timer
                              if (_timer != null) {
                                _timer!.cancel();
                                _timer = null;
                              }
                            });
                          },
                          child: Container(
                            width: celestialBodySize,
                            height: celestialBodySize,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startTimer,
                  child: const Text('Start'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _stopTimer,
                  child: const Text('Stop'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
