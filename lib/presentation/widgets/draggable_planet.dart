import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/planet_position.dart';

class DraggablePlanet extends StatelessWidget {
  const DraggablePlanet({
    super.key,
    required this.position,
    required this.onDrag,
    this.celestialBodySize = AppConstants.earthSize,
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
