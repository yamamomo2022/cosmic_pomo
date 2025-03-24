import 'dart:async'; // Add this import for Timer
import 'dart:math' show pi, cos, sin; // Add this import for circular motion

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
  static const int _pomodoroDuration = 25 * 60; // 25 minutes
  int _remainingTime = _pomodoroDuration;
  Timer? _timer;

  // Animation controller for circular motion
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    // Create animation that repeats continuously
    _animation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(_animationController);

    // Start the animation
    _animationController.repeat();
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
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
  }

  void _resetTimer() {
    setState(() {
      _remainingTime = _pomodoroDuration;
      if (_timer != null) {
        _timer!.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // ...existing timer methods...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Circular motion animation
            SizedBox(
              height: 200,
              width: 200,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  // Calculate position in circular path
                  final radius = 80.0;
                  final centerX = 100.0;
                  final centerY = 100.0;
                  final x = centerX + radius * cos(_animation.value);
                  final y = centerY + radius * sin(_animation.value);

                  return Stack(
                    children: [
                      // Circular path (optional)
                      Center(
                        child: Container(
                          width: radius * 2,
                          height: radius * 2,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      // Moving circular object
                      Positioned(
                        left: x - 15, // Adjust for circle radius
                        top: y - 15, // Adjust for circle radius
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Colors.deepPurple,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Pomodoro Timer: ${_formatTime(_remainingTime)}',
              style: Theme.of(context).textTheme.headlineMedium,
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
