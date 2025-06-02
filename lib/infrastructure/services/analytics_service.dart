import 'package:firebase_analytics/firebase_analytics.dart';
import '../../domain/repositories/analytics_repository.dart';

class AnalyticsService implements AnalyticsRepository {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  Future<void> logTimerStart(String mode) async {
    await _analytics.logEvent(
      name: 'timer_start',
      parameters: {'mode': mode},
    );
  }

  @override
  Future<void> logTimerComplete(String mode) async {
    await _analytics.logEvent(
      name: 'timer_complete',
      parameters: {'mode': mode},
    );
  }

  @override
  Future<void> logModeSwitch(String fromMode, String toMode) async {
    await _analytics.logEvent(
      name: 'mode_switch',
      parameters: {
        'from_mode': fromMode,
        'to_mode': toMode,
      },
    );
  }
}
