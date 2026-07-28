import 'package:flutter/widgets.dart';

/// Spacing scale. Everything in the UI is a multiple of 4, and in practice
/// almost everything is one of these named steps.
class AppSpacing {
  AppSpacing._();

  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;
  static const huge = 40.0;

  /// Standard horizontal page gutter.
  static const gutter = 20.0;

  /// Bottom padding for scrollable pages, so content clears the nav bar and
  /// the floating SOS button.
  static const scrollBottom = 120.0;
}

/// Corner radii. Cards and sheets are generously rounded — hard corners read
/// as clinical, and this app is trying not to feel like a medical form.
class AppRadius {
  AppRadius._();

  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const pill = 999.0;

  static const cardBorder = BorderRadius.all(Radius.circular(md));
  static const sheetBorder = BorderRadius.vertical(top: Radius.circular(xl));
  static const pillBorder = BorderRadius.all(Radius.circular(pill));
}

/// Motion. Recovery-app animation should be slower than product-app default:
/// calm, never snappy or attention-grabbing.
class AppDuration {
  AppDuration._();

  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 260);
  static const slow = Duration(milliseconds: 420);

  /// One phase of the SOS box-breathing cycle (in / hold / out / hold).
  static const breathPhase = Duration(seconds: 4);
}

/// Minimum tap target. Larger than Material's 48dp default on the SOS and
/// check-in paths — fine motor control is worse under distress.
class AppTouch {
  AppTouch._();

  static const min = 48.0;
  static const comfortable = 56.0;
  static const distress = 72.0;
}
