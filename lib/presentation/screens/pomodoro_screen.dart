import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/providers/pomodoro_providers.dart';
import '../../constants/app_constants.dart';
import '../../enum/pomodoro_mode.dart';
import '../../infrastructure/services/ad_service.dart';
import '../../utils/logger.dart';
import '../widgets/mode_toggle_button.dart';
import '../widgets/orbital_animation.dart';
import '../widgets/timer_controls.dart';
import '../widgets/timer_display.dart';

class PomodoroScreen extends ConsumerStatefulWidget {
  const PomodoroScreen({super.key});

  @override
  ConsumerState<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends ConsumerState<PomodoroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: AppConstants.pomodoroDuration),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: AppConstants.fullCircle,
    ).animate(_animationController);

    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = AdService.createBannerAd(
      onAdLoaded: (_) {
        setState(() {
          _isBannerAdReady = true;
        });
      },
      onAdFailedToLoad: (ad, err) {
        logger.d('Failed to load a banner ad: ${err.message}');
        _isBannerAdReady = false;
        ad.dispose();
      },
    );
    _bannerAd?.load();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(pomodoroSessionProvider);
    final timerService = ref.read(pomodoroSessionProvider.notifier);

    _animationController.value = session.currentTimer.animationValue;

    final Color currentModeColor =
        session.currentMode == PomodoroMode.workMode
            ? AppConstants.planetColor
            : AppConstants.breakModePlanetColor;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppConstants.backgroundGradientStart,
              AppConstants.backgroundGradientMiddle,
              AppConstants.backgroundGradientEnd,
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: AppConstants.smallSpacing / 2),
                    Text(
                      '${session.currentModeName} Mode',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: currentModeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.smallSpacing),
                    TimerDisplay(remainingTime: session.currentTimer.remainingTime),
                    const SizedBox(height: AppConstants.smallSpacing),
                    OrbitalAnimation(
                      animation: _animation,
                      onPlanetDragged: (newAngle) => timerService.updateTimerFromPlanetPosition(
                        newAngle,
                        AppConstants.fullCircle,
                      ),
                      planetColor: currentModeColor,
                    ),
                    const SizedBox(height: AppConstants.smallSpacing),
                    TimerControls(
                      onStart: () => timerService.startTimer(),
                      onStop: () => timerService.stopTimer(),
                      onReset: () => timerService.resetTimer(),
                    ),
                    ModeToggleButton(
                      currentMode: session.currentMode,
                      modeColor: currentModeColor,
                      onToggle: () {
                        timerService.stopTimer();
                        timerService.toggleMode();
                        timerService.resetTimer();
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (_isBannerAdReady && _bannerAd != null)
              SafeArea(
                child: SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
