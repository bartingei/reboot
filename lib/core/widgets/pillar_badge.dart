import 'package:flutter/material.dart';

import '../db/app_database.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';

/// Small tinted label identifying which pillar a row belongs to.
class PillarBadge extends StatelessWidget {
  const PillarBadge({super.key, required this.pillar, this.dense = false});

  final Pillar pillar;
  final bool dense;

  static String labelFor(Pillar pillar) =>
      pillar == Pillar.recovery ? 'Recovery' : 'Growth';

  static IconData iconFor(Pillar pillar) =>
      pillar == Pillar.recovery ? Icons.shield_outlined : Icons.eco_outlined;

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;
    final isRecovery = pillar == Pillar.recovery;
    final accent = tokens.pillar(isRecovery: isRecovery);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? AppSpacing.sm : AppSpacing.md,
        vertical: dense ? 3 : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: tokens.pillarSoft(isRecovery: isRecovery),
        borderRadius: AppRadius.pillBorder,
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconFor(pillar), size: dense ? 12 : 14, color: accent),
          const SizedBox(width: AppSpacing.xs),
          Text(
            labelFor(pillar),
            style: context.text.labelSmall?.copyWith(
              color: accent,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact metric readout used in rows of two or three (e.g. "7 days",
/// "12 check-ins", "3 wins").
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.value,
    required this.label,
    this.accent,
    this.icon,
  });

  final String value;
  final String label;
  final Color? accent;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;
    final color = accent ?? context.colors.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: tokens.surfaceSunken,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: tokens.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: color),
            const SizedBox(height: AppSpacing.sm),
          ],
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.titleLarge?.copyWith(color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.text.labelSmall,
          ),
        ],
      ),
    );
  }
}
