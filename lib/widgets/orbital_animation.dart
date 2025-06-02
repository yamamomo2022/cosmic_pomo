import 'package:cosmic_pomo/constants/app_constants.dart';
import 'package:cosmic_pomo/models/planet_position.dart';
import 'package:cosmic_pomo/presentation/widgets/draggable_planet.dart';
import 'package:cosmic_pomo/presentation/widgets/orbit_path.dart';
import 'package:cosmic_pomo/presentation/widgets/sun.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class OrbitalAnimation extends StatelessWidget {
  const OrbitalAnimation({
    super.key,
    required this.animation,
    required this.onPlanetDragged,
    this.planetColor = AppConstants.planetColor,
  });

  final Animation<double> animation;
  final Function(double) onPlanetDragged;
  final Color planetColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final angle = animation.value * AppConstants.fullCircle;
        final planetPosition = _calculatePlanetPosition(angle);

        return Stack(
          children: [
            const OrbitPath(),
            const Sun(),
            DraggablePlanet(
              position: planetPosition,
              onDrag: (details, position) {
                final newAngle = _calculateAngleFromPosition(details.globalPosition);
                onPlanetDragged(newAngle);
              },
              planetColor: planetColor,
            ),
          ],
        );
      },
    );
  }

  PlanetPosition _calculatePlanetPosition(double angle) {
    final x = AppConstants.centerPoint + AppConstants.orbitRadius * cos(angle);
    final y = AppConstants.centerPoint + AppConstants.orbitRadius * sin(angle);
    return PlanetPosition(x: x, y: y, radius: AppConstants.earthSize / 2);
  }

  double _calculateAngleFromPosition(Offset position) {
    final dx = position.dx - AppConstants.centerPoint;
    final dy = position.dy - AppConstants.centerPoint;
    return atan2(dy, dx);
  }
}
