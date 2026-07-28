import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';

/// Type scale.
///
/// Deliberately uses the platform default font: no font assets to ship, no
/// network fetch, and system text respects the user's accessibility font
/// settings out of the box. To swap in a brand face later, set
/// [fontFamily] here (or return `GoogleFonts.xTextTheme(base)` from
/// [textTheme]) — nothing else in the app names a font.
class AppTypography {
  AppTypography._();

  static const String? fontFamily = null;

  /// Streak counts and other big numerals. Tabular figures stop the number
  /// from jittering as it ticks up.
  static const TextStyle numeral = TextStyle(
    fontFamily: fontFamily,
    fontSize: 52,
    height: 1.05,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle numeralSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    height: 1.1,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static TextTheme textTheme(Color onSurface, Color onSurfaceVariant) {
    TextStyle primary(double size, double height, FontWeight weight,
        [double spacing = 0]) {
      return TextStyle(
        fontFamily: fontFamily,
        fontSize: size,
        height: height / size,
        fontWeight: weight,
        letterSpacing: spacing,
        color: onSurface,
      );
    }

    return TextTheme(
      // Screen titles ("Today", "Journal").
      displaySmall: primary(32, 40, FontWeight.w600, -0.5),
      headlineMedium: primary(26, 34, FontWeight.w600, -0.3),
      headlineSmall: primary(22, 30, FontWeight.w600, -0.2),
      // Card titles and section headers.
      titleLarge: primary(19, 26, FontWeight.w600),
      titleMedium: primary(16, 22, FontWeight.w600),
      titleSmall: primary(14, 20, FontWeight.w600),
      // Reading text. 16/24 body — journal entries get read, not scanned.
      bodyLarge: primary(16, 24, FontWeight.w400),
      bodyMedium: primary(15, 22, FontWeight.w400),
      bodySmall: primary(13, 19, FontWeight.w400)
          .copyWith(color: onSurfaceVariant),
      // Buttons, chips, metadata.
      labelLarge: primary(15, 20, FontWeight.w600, 0.1),
      labelMedium: primary(13, 18, FontWeight.w500, 0.2),
      labelSmall: primary(11, 16, FontWeight.w500, 0.6)
          .copyWith(color: onSurfaceVariant),
    );
  }
}
