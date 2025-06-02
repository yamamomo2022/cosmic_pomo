import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

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
        ElevatedButton.icon(
          onPressed: onStart,
          icon: const Icon(Icons.play_arrow),
          label: Text('start'),
        ),
        const SizedBox(width: AppConstants.controlButtonSpacing),
        ElevatedButton.icon(
          onPressed: onStop,
          icon: const Icon(Icons.stop),
          label: Text('Stop'),
        ),
        const SizedBox(width: AppConstants.controlButtonSpacing),
        ElevatedButton.icon(
          onPressed: onReset,
          icon: const Icon(Icons.refresh),
          label: Text('Reset'),
        ),
      ],
    );
  }
}
