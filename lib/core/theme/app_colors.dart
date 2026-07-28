import 'package:flutter/material.dart';

/// Raw color tokens for the reboot palette.
///
/// Screens should not reference these directly — read semantic colors from
/// `Theme.of(context).colorScheme` or from the [RebootColors] theme
/// extension (see `app_theme.dart`), so light and dark stay in sync.
///
/// The palette is deliberately low-saturation. Recovery apps get opened on
/// bad days, often at night; high-chroma UI reads as demanding. See
/// DESIGN.md for the reasoning behind each ramp.
class AppColors {
  AppColors._();

  /// Sage — primary. Steadiness, the recovery pillar.
  static const sage50 = Color(0xFFEDF6F0);
  static const sage100 = Color(0xFFD3E8DB);
  static const sage200 = Color(0xFFAFD7C0);
  static const sage300 = Color(0xFF8FC7A9);
  static const sage500 = Color(0xFF4E9C7F);
  static const sage600 = Color(0xFF3E8168);
  static const sage700 = Color(0xFF2F6B55);
  static const sage900 = Color(0xFF16342A);

  /// Iris — the growth pillar. Distinct from sage at a glance, but the
  /// same lightness so neither pillar reads as "the important one".
  static const iris100 = Color(0xFFE0E1F7);
  static const iris300 = Color(0xFFB7B8F0);
  static const iris500 = Color(0xFF7B7DD6);
  static const iris700 = Color(0xFF4A4C99);
  static const iris900 = Color(0xFF23244D);

  /// Amber — wins, milestones, badges. The only celebratory color.
  static const amber100 = Color(0xFFFAEBCC);
  static const amber300 = Color(0xFFF3D08A);
  static const amber500 = Color(0xFFE0A64B);
  static const amber700 = Color(0xFF9A6C22);

  /// Ember — SOS and craving intensity. Warm coral rather than alarm red:
  /// it has to be unmistakable without adding panic to a panic moment.
  static const ember100 = Color(0xFFF9DED5);
  static const ember300 = Color(0xFFF2B3A0);
  static const ember500 = Color(0xFFE07A5F);
  static const ember700 = Color(0xFF9C4A34);
  static const ember900 = Color(0xFF3A1B13);

  /// Dusk — neutrals. Slightly green-blue rather than pure grey so they sit
  /// under the sage without looking dirty.
  static const dusk0 = Color(0xFFFFFFFF);
  static const dusk50 = Color(0xFFF6F8F7);
  static const dusk100 = Color(0xFFE8EDEB);
  static const dusk200 = Color(0xFFCBD5D1);
  static const dusk300 = Color(0xFFAAB8B3);
  static const dusk400 = Color(0xFF8A9A95);
  static const dusk500 = Color(0xFF6B7B76);
  static const dusk600 = Color(0xFF4A5A56);
  static const dusk700 = Color(0xFF2C3A37);
  static const dusk800 = Color(0xFF1E2927);
  static const dusk900 = Color(0xFF131B1A);
  static const dusk950 = Color(0xFF0B1110);
}
