import 'package:cosmic_pomo/constants/app_constants.dart';
import 'package:flutter/material.dart';

/// Widget that displays the orbital path
class OrbitPath extends StatelessWidget {
  const OrbitPath({
    super.key,
    this.orbitRadius = AppConstants.orbitRadius,
    this.orbitColor = AppConstants.orbitColor,
    this.borderWidth = 2.0,
    this.opacity = 0.3,
  });

  final double orbitRadius;
  final Color orbitColor;
  final double borderWidth;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: orbitRadius * 2,
        height: orbitRadius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: orbitColor.withOpacity(opacity),
            width: borderWidth,
          ),
        ),
      ),
    );
  }
}

/// Widget that displays the sun at the center
class Sun extends StatelessWidget {
  const Sun({
    super.key,
    this.celestialBodySize = AppConstants.celestialBodySize,
    this.centerPoint = AppConstants.centerPoint,
    this.sunColor = AppConstants.sunColor,
  });

  final double celestialBodySize;
  final double centerPoint;
  final Color sunColor;

  @override
  Widget build(BuildContext context) {
    final double celestialBodyRadius = celestialBodySize / 2;

    return Positioned(
      left: centerPoint - celestialBodyRadius,
      top: centerPoint - celestialBodyRadius,
      child: Container(
        width: celestialBodySize,
        height: celestialBodySize,
        decoration: BoxDecoration(color: sunColor, shape: BoxShape.circle),
      ),
    );
  }
}

/// Represents the position of a planet
class PlanetPosition {
  const PlanetPosition({
    required this.x,
    required this.y,
    required this.radius,
  });

  final double x;
  final double y;
  final double radius;
}

/// Widget that displays the draggable planet
class DraggablePlanet extends StatelessWidget {
  const DraggablePlanet({
    super.key,
    required this.position,
    required this.onDrag,
    this.celestialBodySize = AppConstants.celestialBodySize,
    this.planetColor = AppConstants.planetColor,
  });

  final PlanetPosition position;
  final void Function(DragUpdateDetails, PlanetPosition) onDrag;
  final double celestialBodySize;
  final Color planetColor;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.x - position.radius,
      top: position.y - position.radius,
      child: GestureDetector(
        onPanUpdate: (details) => onDrag(details, position),
        child: Container(
          width: celestialBodySize,
          height: celestialBodySize,
          decoration: BoxDecoration(color: planetColor, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
