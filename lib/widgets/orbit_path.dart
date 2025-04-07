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
