import 'package:cosmic_pomo/constants/app_constants.dart';
import 'package:cosmic_pomo/enum/pomodoro_mode.dart';
import 'package:cosmic_pomo/application/providers/timer_providers.dart';
import 'package:cosmic_pomo/domain/entities/pomodoro_session.dart';
import 'package:cosmic_pomo/widgets/mode_toggle_button.dart';
import 'package:cosmic_pomo/widgets/orbital_animation.dart';
import 'package:cosmic_pomo/widgets/timer_controls.dart';
import 'package:cosmic_pomo/widgets/timer_display.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../ad_helper.dart';

class PomodoroScreen extends ConsumerStatefulWidget {
  const PomodoroScreen({super.key});

  @override
  ConsumerState<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends ConsumerState<PomodoroScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _loadAd();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listen<PomodoroSession>(pomodoroTimerServiceProvider, (previous, next) {
        _updateAnimation();
      });
    });
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {});
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  void _updateAnimation() {
    final session = ref.read(pomodoroTimerServiceProvider);
    _animationController.value = session.currentTimer.animationValue;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(pomodoroTimerServiceProvider);
    final timerService = ref.read(pomodoroTimerServiceProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cosmic Pomo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black,
                ),
                Center(
                  child: SizedBox(
                    width: AppConstants.animationSize,
                    height: AppConstants.animationSize,
                    child: OrbitalAnimation(
                      animation: _animationController,
                      onPlanetDragged: (newAngle) {
                        timerService.updateTimerFromPlanetPosition(newAngle, AppConstants.fullCircle);
                      },
                      planetColor: session.currentMode == PomodoroMode.workMode
                          ? AppConstants.planetColor
                          : AppConstants.breakModePlanetColor,
                    ),
                  ),
                ),
                const Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: TimerDisplay(),
                ),
                Positioned(
                  bottom: 120,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      const TimerControls(),
                      const SizedBox(height: 20),
                      const ModeToggleButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_bannerAd != null)
            Container(
              alignment: Alignment.center,
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
    );
  }
}
