import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class Sun extends StatelessWidget {
  const Sun({
    super.key,
    this.celestialBodySize = AppConstants.sunSize,
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
