import 'package:wakelock_plus/wakelock_plus.dart';
import '../../domain/repositories/wakelock_repository.dart';
import '../../utils/logger.dart';

class WakelockRepositoryImpl implements WakelockRepository {
  @override
  Future<void> enable() async {
    try {
      await WakelockPlus.enable();
      logger.d('Wakelock enabled');
    } catch (e) {
      logger.e('Error enabling wakelock: $e');
    }
  }

  @override
  Future<void> disable() async {
    try {
      await WakelockPlus.disable();
      logger.d('Wakelock disabled');
    } catch (e) {
      logger.e('Error disabling wakelock: $e');
    }
  }
}
