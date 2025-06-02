import 'package:firebase_analytics/firebase_analytics.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../../utils/logger.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  Future<void> logAppOpen() async {
    try {
      await _analytics.logAppOpen();
      logger.d('Analytics: App opened');
    } catch (e) {
      logger.e('Error logging app open: $e');
    }
  }

  @override
  Future<void> logTimerStart(String mode) async {
    try {
      await _analytics.logEvent(
        name: 'timer_start',
        parameters: {'mode': mode},
      );
      logger.d('Analytics: Timer started - $mode');
    } catch (e) {
      logger.e('Error logging timer start: $e');
    }
  }

  @override
  Future<void> logTimerComplete(String mode) async {
    try {
      await _analytics.logEvent(
        name: 'timer_complete',
        parameters: {'mode': mode},
      );
      logger.d('Analytics: Timer completed - $mode');
    } catch (e) {
      logger.e('Error logging timer complete: $e');
    }
  }

  @override
  Future<void> logModeToggle(String fromMode, String toMode) async {
    try {
      await _analytics.logEvent(
        name: 'mode_toggle',
        parameters: {
          'from_mode': fromMode,
          'to_mode': toMode,
        },
      );
      logger.d('Analytics: Mode toggled from $fromMode to $toMode');
    } catch (e) {
      logger.e('Error logging mode toggle: $e');
    }
  }
}
