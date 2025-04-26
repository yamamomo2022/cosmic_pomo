import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'firebase_options.dart';
import 'screens/pomodoro_screen.dart';
import 'utils/logger.dart';

/// FirebaseAnalyticsのインスタンス
final analyticsRepository = Provider((ref) => FirebaseAnalytics.instance);

/// FirebaseAnalyticsObserverのインスタンス
final analyticsObserverRepository = Provider(
  (ref) => FirebaseAnalyticsObserver(analytics: ref.watch(analyticsRepository)),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    logger.e('Firebase initialization error: $e');
  }

  // Google Mobile Ads SDKを初期化する
  await MobileAds.instance.initialize();

  // 画面の向きを縦向きに固定する。
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  logger.d('App started');
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var analytics = ref.watch(analyticsRepository);
    var analyticsObserver = ref.watch(analyticsObserverRepository);

    analytics.logAppOpen();
    logger.d('FirebaseAnalytics instance: $analytics');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cosmic Pomo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PomodoroScreen(),
      navigatorObservers: [analyticsObserver],
    );
  }
}
