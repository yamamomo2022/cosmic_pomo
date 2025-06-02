import 'package:cosmic_pomo/application/providers/timer_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ModeToggleButton extends ConsumerWidget {
  const ModeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(pomodoroTimerServiceProvider);
    final timerService = ref.read(pomodoroTimerServiceProvider.notifier);

    return ElevatedButton(
      onPressed: () => timerService.toggleMode(),
      child: Text('Switch to ${session.currentModeName}'),
    );
  }
}
