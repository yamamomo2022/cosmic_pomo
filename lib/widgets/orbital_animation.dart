import 'dart:math' show cos, sin, atan2;

import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import 'celestial_bodies.dart';

class OrbitalAnimation extends StatelessWidget {
  const OrbitalAnimation({
    super.key,
    required this.animation,
    required this.onPlanetDragged,
  });

  final Animation<double> animation;
  final Function(double) onPlanetDragged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          // Calculate planet position - subtract pi/2 to start from top position
          final double planetAngle = animation.value + AppConstants.topPosition;
          final planetPosition = _calculatePlanetPosition(planetAngle);

          return Stack(
            children: [
              OrbitPath(),
              Sun(),
              DraggablePlanet(
                position: planetPosition,
                onDrag: _handlePlanetDrag,
              ),
            ],
          );
        },
      ),
    );
  }

  Map<String, double> _calculatePlanetPosition(double angle) {
    const double celestialBodyRadius = AppConstants.celestialBodySize / 2;

    final double x =
        AppConstants.centerPoint + AppConstants.orbitRadius * cos(angle);
    final double y =
        AppConstants.centerPoint + AppConstants.orbitRadius * sin(angle);

    return {'x': x, 'y': y, 'radius': celestialBodyRadius};
  }

  void _handlePlanetDrag(
    DragUpdateDetails details,
    Map<String, double> position,
  ) {
    // Calculate drag position relative to orbit center
    final double dragX =
        details.localPosition.dx +
        position['x']! -
        position['radius']! -
        AppConstants.centerPoint;
    final double dragY =
        details.localPosition.dy +
        position['y']! -
        position['radius']! -
        AppConstants.centerPoint;

    // Calculate angle from drag position
    double newAngle = atan2(dragY, dragX) - AppConstants.topPosition;
    if (newAngle < 0) newAngle += AppConstants.fullCircle;

    onPlanetDragged(newAngle);
  }
}
