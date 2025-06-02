// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cosmic_pomo/main.dart';
import 'package:cosmic_pomo/application/providers/timer_providers.dart';
import 'package:cosmic_pomo/domain/entities/pomodoro_session.dart';

void main() {
  testWidgets('Cosmic Pomo app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pomodoroTimerServiceProvider.overrideWith((ref) => MockPomodoroTimerService()),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.text('Cosmic Pomo'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Stop'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
  });
}

class MockPomodoroTimerService extends StateNotifier<PomodoroSession> {
  MockPomodoroTimerService() : super(PomodoroSession());

  Future<void> startTimer() async {}
  Future<void> stopTimer() async {}
  void resetTimer() {}
  Future<void> toggleMode() async {}
  void updateTimerFromPlanetPosition(double newAngle, double fullCircle) {}
}
