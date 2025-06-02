import 'package:wakelock_plus/wakelock_plus.dart';
import '../../domain/repositories/wakelock_repository.dart';

class WakelockService implements WakelockRepository {
  @override
  Future<void> enable() async {
    await WakelockPlus.enable();
  }

  @override
  Future<void> disable() async {
    await WakelockPlus.disable();
  }
}
