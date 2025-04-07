import 'package:cosmic_pomo/utils/time_formatter.dart';
import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  final int remainingTime;

  const TimerDisplay({super.key, required this.remainingTime});

  @override
  Widget build(BuildContext context) {
    final TextStyle headlineStyle =
        Theme.of(
          context,
        ).textTheme.headlineMedium?.copyWith(color: Colors.white) ??
        const TextStyle(color: Colors.white, fontSize: 24);

    return Text(
      TimeFormatter.formatTime(remainingTime),
      style: headlineStyle.copyWith(fontSize: 48, fontWeight: FontWeight.bold),
    );
  }
}
