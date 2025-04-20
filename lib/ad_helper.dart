import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return '<YOUR_ANDROID_BANNER_AD_UNIT_ID>';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3669200815742909/4474422857';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
