abstract class AnalyticsRepository {
  Future<void> logAppOpen();
  Future<void> logTimerStart(String mode);
  Future<void> logTimerComplete(String mode);
  Future<void> logModeToggle(String fromMode, String toMode);
}
