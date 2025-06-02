import 'dart:math' show cos, sin, atan2;

import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/planet_position.dart';
import 'celestial_bodies.dart';

class OrbitalAnimation extends StatelessWidget {
  const OrbitalAnimation({
    super.key,
    required this.animation,
    required this.onPlanetDragged,
    required this.planetColor,
  });

  final Animation<double> animation;
  final void Function(double) onPlanetDragged;
  final Color planetColor;

  PlanetPosition _calculatePlanetPosition(double angle) {
    const double celestialBodyRadius = AppConstants.earthSize / 2;

    final double x =
        AppConstants.centerPoint + AppConstants.orbitRadius * cos(angle);
    final double y =
        AppConstants.centerPoint + AppConstants.orbitRadius * sin(angle);

    return PlanetPosition(x: x, y: y, radius: celestialBodyRadius);
  }

  void _handlePlanetDrag(DragUpdateDetails details, PlanetPosition position) {
    final double dragX =
        position.x -
        position.radius +
        details.localPosition.dx -
        AppConstants.centerPoint;
    final double dragY =
        position.y -
        position.radius +
        details.localPosition.dy -
        AppConstants.centerPoint;

    double newAngle = atan2(dragY, dragX) - AppConstants.topPosition;
    if (newAngle < 0) newAngle += AppConstants.fullCircle;

    onPlanetDragged(newAngle);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
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
}
