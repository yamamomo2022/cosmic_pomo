import 'dart:math' show pi;

import 'package:flutter/material.dart';

/// Constants for the Pomodoro timer app
class AppConstants {
  // Timer constants
  static const int pomodoroDuration = 25 * 60; // 25 minutes in seconds

  // Celestial body properties
  static const double orbitRadius = 80.0;
  static const double centerPoint = 100.0;
  static const double celestialBodySize = 30.0;
  static const Color sunColor = Colors.red;
  static const Color planetColor = Colors.blue;
  static const Color orbitColor = Colors.grey;

  // Animation constants
  static const double fullCircle = 2 * pi;
  static const double topPosition = -pi / 2; // Start from top (12 o'clock)

  // UI spacing
  static const double standardSpacing = 120.0;
  static const double controlButtonSpacing = 24.0;
}
