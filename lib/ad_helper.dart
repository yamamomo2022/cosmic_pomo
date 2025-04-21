import 'dart:io';

import '../utils/logger.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3669200815742909/6124354360';
    } else {
      logger.e('Unsupported platform: ${Platform.operatingSystem}');
      return ''; // Or return null
    }
  }
}
