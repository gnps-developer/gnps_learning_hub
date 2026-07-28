import 'package:flutter/material.dart';

/// Centralized design system constants for colors, spacing, and durations.
class AppColors {
  AppColors._();

  // Semantic Status Colors
  static const success = Colors.green;
  static const error = Colors.red;
  static const warning = Colors.orange;
  static const heart = Colors.red;
  static const streak = Colors.orange;

  // Trophy Colors
  static const bronze = Color(0xFFCD7F32);
  static const silver = Color(0xFFC0C0C0);
  static const gold = Color(0xFFFFD700);

  // Backgrounds & Overlays
  static final overlayDark = Colors.black.withValues(alpha: 0.85);
  static final barrierDark = Colors.black.withValues(alpha: 0.5);

  // Shadows (using standard Material values)
  static final shadowLight = Colors.black.withValues(alpha: 0.1);
  static final shadowMedium = Colors.black.withValues(alpha: 0.3);
  static final shadowDark = Colors.black.withValues(alpha: 0.5);
}

class AppSpacing {
  AppSpacing._();

  static const xs = 4.0;
  static const sm = 8.0;
  static const ms = 12.0;
  static const md = 16.0;
  static const ml = 20.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

class AppDurations {
  AppDurations._();

  static const fast = Duration(milliseconds: 200);
  static const medium = Duration(milliseconds: 400);
  static const slow = Duration(milliseconds: 800);
  static const celebration = Duration(milliseconds: 1500);
}
