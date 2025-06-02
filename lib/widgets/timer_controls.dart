import 'package:cosmic_pomo/application/providers/timer_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimerControls extends ConsumerWidget {
  const TimerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(pomodoroTimerServiceProvider);
    final timerService = ref.read(pomodoroTimerServiceProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: session.currentTimer.isRunning ? null : () => timerService.startTimer(),
          child: const Text('Start'),
        ),
        ElevatedButton(
          onPressed: session.currentTimer.isRunning ? () => timerService.stopTimer() : null,
          child: const Text('Stop'),
        ),
        ElevatedButton(
          onPressed: () => timerService.resetTimer(),
          child: const Text('Reset'),
        ),
      ],
    );
  }
}
