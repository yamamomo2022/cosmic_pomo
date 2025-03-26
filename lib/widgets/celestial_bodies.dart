import 'package:cosmic_pomo/constants/app_constants.dart';
import 'package:flutter/material.dart';

/// Widget that displays the orbital path
class OrbitPath extends StatelessWidget {
  const OrbitPath({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: AppConstants.orbitRadius * 2,
        height: AppConstants.orbitRadius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppConstants.orbitColor.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
    );
  }
}

/// Widget that displays the sun at the center
class Sun extends StatelessWidget {
  const Sun({super.key});

  @override
  Widget build(BuildContext context) {
    const double celestialBodyRadius = AppConstants.celestialBodySize / 2;

    return Positioned(
      left: AppConstants.centerPoint - celestialBodyRadius,
      top: AppConstants.centerPoint - celestialBodyRadius,
      child: Container(
        width: AppConstants.celestialBodySize,
        height: AppConstants.celestialBodySize,
        decoration: const BoxDecoration(
          color: AppConstants.sunColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Widget that displays the draggable planet
class DraggablePlanet extends StatelessWidget {
  const DraggablePlanet({
    super.key,
    required this.position,
    required this.onDrag,
  });

  final Map<String, double> position;
  final void Function(DragUpdateDetails, Map<String, double>) onDrag;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position['x']! - position['radius']!,
      top: position['y']! - position['radius']!,
      child: GestureDetector(
        onPanUpdate: (details) => onDrag(details, position),
        child: Container(
          width: AppConstants.celestialBodySize,
          height: AppConstants.celestialBodySize,
          decoration: const BoxDecoration(
            color: AppConstants.planetColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
