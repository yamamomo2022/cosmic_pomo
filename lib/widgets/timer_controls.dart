import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class TimerControls extends StatelessWidget {
  const TimerControls({
    super.key,
    required this.onStart,
    required this.onStop,
    required this.onReset,
  });

  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: onStart, child: const Text('Start')),
        const SizedBox(width: AppConstants.controlButtonSpacing),
        ElevatedButton(onPressed: onStop, child: const Text('Stop')),
        const SizedBox(width: AppConstants.controlButtonSpacing),
        ElevatedButton(onPressed: onReset, child: const Text('Reset')),
      ],
    );
  }
}
