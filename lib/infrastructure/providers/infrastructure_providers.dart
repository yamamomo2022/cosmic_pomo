import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/repositories/audio_repository.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../../domain/repositories/wakelock_repository.dart';
import '../services/audio_service.dart';
import '../services/analytics_service.dart';
import '../services/wakelock_service.dart';

final audioRepositoryProvider = Provider<AudioRepository>((ref) {
  return AudioService();
});

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsService();
});

final wakelockRepositoryProvider = Provider<WakelockRepository>((ref) {
  return WakelockService();
});
