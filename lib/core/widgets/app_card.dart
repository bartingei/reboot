import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';

/// The app's one card surface. Flat fill, hairline border, generous radius —
/// no drop shadows, which read as heavy against the dark palette.
///
/// Pass [accent] to tint the card for a pillar or a milestone; the tint is a
/// low-alpha wash over the raised surface plus a matching border, never a
/// fully saturated fill.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.accent,
    this.onTap,
    this.borderRadius = AppRadius.md,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? accent;
  final VoidCallback? onTap;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;
    final radius = BorderRadius.circular(borderRadius);
    final accentColor = accent;

    return Material(
      color: accentColor == null
          ? tokens.surfaceRaised
          : Color.alphaBlend(
              accentColor.withValues(alpha: 0.10),
              tokens.surfaceRaised,
            ),
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: accentColor == null
                  ? tokens.hairline
                  : accentColor.withValues(alpha: 0.28),
            ),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
