import 'package:flutter/material.dart';

/// Helper class to handle responsive scaling on mobile devices.
/// Assumes a base design size of 375 x 812 (standard mobile size, e.g., iPhone X).
class ResponsiveHelper {
  static double screenWidth = 375.0;
  static double screenHeight = 812.0;
  static double devicePixelRatio = 2.0;
  static bool _initialized = false;

  static const double _designWidth = 375.0;
  static const double _designHeight = 812.0;

  /// Initialize the helper with the current [BuildContext].
  /// Call this at the start of the build method of the root or screen widget.
  static void init(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    screenWidth = size.width;
    screenHeight = size.height;
    devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    _initialized = true;
  }

  /// Scale width proportionally to the design width.
  static double sw(num value) {
    if (!_initialized) return value.toDouble();
    return (value * screenWidth) / _designWidth;
  }

  /// Scale height proportionally to the design height.
  static double sh(num value) {
    if (!_initialized) return value.toDouble();
    return (value * screenHeight) / _designHeight;
  }

  /// Scale font size proportionally, with constraints to prevent text from
  /// getting too small or too large.
  static double sf(num value) {
    if (!_initialized) return value.toDouble();
    final scale = screenWidth / _designWidth;
    // Limit font scale factor between 0.85 and 1.25 to prevent extreme sizing
    final clampedScale = scale.clamp(0.85, 1.25);
    return value * clampedScale;
  }

  /// Helper to create a responsive symmetric padding.
  static EdgeInsets sp(num horizontal, num vertical) {
    return EdgeInsets.symmetric(
      horizontal: sw(horizontal),
      vertical: sh(vertical),
    );
  }

  /// Helper to retrieve the current screen width.
  static double get width => screenWidth;

  /// Helper to retrieve the current screen height.
  static double get height => screenHeight;
}

/// Extensions for easy responsive sizing syntax on numbers (e.g. 24.sw, 16.sh, 14.sf)
extension ResponsiveNumExtension on num {
  double get sw => ResponsiveHelper.sw(this);
  double get sh => ResponsiveHelper.sh(this);
  double get sf => ResponsiveHelper.sf(this);
}
