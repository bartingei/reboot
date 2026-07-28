import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';

/// Five-point mood picker.
///
/// Labelled rather than icon-only: a row of bare faces is ambiguous ("is
/// that one 'fine' or 'flat'?"), and the label is what makes the entry worth
/// re-reading in the journal weeks later.
class MoodSelector extends StatelessWidget {
  const MoodSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.accent,
  });

  /// Selected mood, 1–5.
  final int value;
  final ValueChanged<int> onChanged;
  final Color? accent;

  static const _options = <(int, IconData, String)>[
    (1, Icons.sentiment_very_dissatisfied, 'Rough'),
    (2, Icons.sentiment_dissatisfied, 'Low'),
    (3, Icons.sentiment_neutral, 'Flat'),
    (4, Icons.sentiment_satisfied, 'Good'),
    (5, Icons.sentiment_very_satisfied, 'Great'),
  ];

  static String labelFor(int mood) {
    for (final option in _options) {
      if (option.$1 == mood) return option.$3;
    }
    return '—';
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;
    final selectedColor = accent ?? context.colors.primary;

    return Row(
      children: [
        for (final (mood, icon, label) in _options)
          Expanded(
            child: Semantics(
              selected: mood == value,
              button: true,
              label: label,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(mood),
                child: AnimatedContainer(
                  duration: AppDuration.fast,
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: mood == value
                        ? Color.alphaBlend(
                            selectedColor.withValues(alpha: 0.16),
                            tokens.surfaceSunken,
                          )
                        : tokens.surfaceSunken,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: mood == value
                          ? selectedColor.withValues(alpha: 0.6)
                          : tokens.hairline,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        icon,
                        size: 26,
                        color: mood == value
                            ? selectedColor
                            : context.colors.onSurfaceVariant,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.labelSmall?.copyWith(
                          color: mood == value
                              ? selectedColor
                              : context.colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
