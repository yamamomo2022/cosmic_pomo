import 'package:cosmic_pomo/constants/app_constants.dart';
import 'package:cosmic_pomo/enum/pomodoro_mode.dart';
import 'package:flutter/material.dart';

class ModeToggleButton extends StatelessWidget {
  final PomodoroMode currentMode;
  final Color modeColor;
  final VoidCallback onToggle;

  const ModeToggleButton({
    super.key,
    required this.currentMode,
    required this.modeColor,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final String nextModeName =
        currentMode == PomodoroMode.workMode ? 'Break' : 'Work';

    return Padding(
      padding: const EdgeInsets.only(top: AppConstants.smallSpacing),
      child: TextButton(
        onPressed: onToggle,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: modeColor.withOpacity(0.5), width: 1),
          ),
        ),
        child: Text(
          'Switch to $nextModeName Mode',
          style: TextStyle(
            color: modeColor,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
