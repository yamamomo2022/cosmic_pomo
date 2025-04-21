import 'package:cosmic_pomo/ad_helper.dart';
import 'package:cosmic_pomo/constants/app_constants.dart';
import 'package:cosmic_pomo/enum/pomodoro_mode.dart';
import 'package:cosmic_pomo/services/timer_service.dart';
import 'package:cosmic_pomo/widgets/mode_toggle_button.dart';
import 'package:cosmic_pomo/widgets/orbital_animation.dart';
import 'package:cosmic_pomo/widgets/timer_controls.dart';
import 'package:cosmic_pomo/widgets/timer_display.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../utils/logger.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen>
    with SingleTickerProviderStateMixin {
  // Timer service to handle all timer logic
  final TimerService _timerService = TimerService();

  // Animation controller for circular motion
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Banner Ad state
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller with the total timer duration
    _animationController = AnimationController(
      duration: Duration(
        seconds:
            _timerService.currentMode == PomodoroMode.workMode
                ? AppConstants.pomodoroDuration
                : AppConstants.breakDuration,
      ),
      vsync: this,
    );

    // Animation that moves in the opposite direction of the timer
    _animation = Tween<double>(
      begin: 0,
      end: AppConstants.fullCircle,
    ).animate(_animationController);

    // Listen to changes in timer service and update UI
    _timerService.addListener(_handleTimerServiceUpdate);

    // Load Banner Ad
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          // Handle ad load failure (optional)
          logger.d('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    _bannerAd?.load();
  }

  void _handleTimerServiceUpdate() {
    if (mounted) {
      setState(() {
        // Update animation controller based on timer service values
        _animationController.value = _timerService.animationValue;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timerService.removeListener(_handleTimerServiceUpdate);
    _timerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color currentModeColor =
        _timerService.currentMode == PomodoroMode.workMode
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
                      '${_timerService.getCurrentModeName()} Mode',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: currentModeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.smallSpacing),
                    TimerDisplay(remainingTime: _timerService.remainingTime),
                    const SizedBox(height: AppConstants.smallSpacing),
                    OrbitalAnimation(
                      animation: _animation,
                      onPlanetDragged:
                          _timerService.updateTimerFromPlanetPosition,
                      planetColor: currentModeColor,
                    ),
                    const SizedBox(height: AppConstants.smallSpacing),
                    TimerControls(
                      onStart: _timerService.startTimer,
                      onStop: _timerService.stopTimer,
                      onReset: _timerService.resetTimer,
                    ),
                    ModeToggleButton(
                      currentMode: _timerService.currentMode,
                      modeColor: currentModeColor,
                      onToggle: () {
                        _timerService.stopTimer();
                        _timerService.toggleMode();
                        _timerService.resetTimer();
                      },
                    ),
                  ],
                ),
              ),
            ), // Add Banner Ad Widget at the bottom if ready
            if (_isBannerAdReady && _bannerAd != null)
              SafeArea(
                // Use SafeArea to avoid overlaps with notches/system UI
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
