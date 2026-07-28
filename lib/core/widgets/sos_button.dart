import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';

/// Persistent SOS entry point, pinned above the nav bar on every tab.
///
/// Design constraints, all deliberate:
/// - Always in the same place, so it can be hit without reading the screen.
/// - [AppTouch.distress]-tall — bigger than the usual minimum, because fine
///   motor control drops under distress.
/// - Ember, not red, and no pulsing/flashing: it has to be findable without
///   adding urgency to a moment that already has plenty.
/// - The label says "I need support", not "PANIC" or "RELAPSE" — the word
///   on the button is one the user has to be willing to press in public.
class SosButton extends StatelessWidget {
  const SosButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
      child: Material(
        color: Color.alphaBlend(
          tokens.sos.withValues(alpha: 0.16),
          tokens.surfaceRaised,
        ),
        borderRadius: AppRadius.pillBorder,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            height: AppTouch.distress,
            decoration: BoxDecoration(
              borderRadius: AppRadius.pillBorder,
              border: Border.all(color: tokens.sos.withValues(alpha: 0.45)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.support_rounded, color: tokens.sos, size: 22),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'I need support',
                  style: context.text.labelLarge?.copyWith(color: tokens.sos),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
