import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';

/// Craving-intensity picker, 0–10.
///
/// A row of discrete bars rather than a [Slider]: the value is a
/// self-report, and discrete steps make it easier to answer honestly than a
/// continuous drag that invites fiddling. Bars fill along the calm →
/// intense ramp so the color itself carries the reading.
///
/// Individual bars are far narrower than the 48dp minimum target, so the
/// whole strip handles the gesture — tap anywhere, or drag across it — and
/// exposes a single slider semantics node instead of eleven tiny buttons.
class IntensityScale extends StatelessWidget {
  const IntensityScale({
    super.key,
    required this.value,
    required this.onChanged,
    this.max = 10,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int max;

  static String descriptorFor(int value) {
    if (value <= 0) return 'None';
    if (value <= 3) return 'Manageable';
    if (value <= 6) return 'Noticeable';
    if (value <= 8) return 'Strong';
    return 'Overwhelming';
  }

  void _selectAt(double dx, double width) {
    if (width <= 0) return;
    final step = width / (max + 1);
    final index = (dx / step).floor().clamp(0, max);
    if (index != value) onChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;
    final activeColor = tokens.cravingColor(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          slider: true,
          value: '$value out of $max, ${descriptorFor(value)}',
          onIncrease: value < max ? () => onChanged(value + 1) : null,
          onDecrease: value > 0 ? () => onChanged(value - 1) : null,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (d) => _selectAt(d.localPosition.dx, width),
                onHorizontalDragUpdate: (d) =>
                    _selectAt(d.localPosition.dx, width),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var i = 0; i <= max; i++)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Column(
                            children: [
                              AnimatedContainer(
                                duration: AppDuration.fast,
                                curve: Curves.easeOut,
                                height: i == value ? 48 : 32,
                                decoration: BoxDecoration(
                                  color: i <= value
                                      ? tokens.cravingColor(i)
                                      : tokens.surfaceSunken,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.sm),
                                  border: Border.all(
                                    color: i == value
                                        ? activeColor
                                        : tokens.hairline,
                                    width: i == value ? 1.5 : 1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                '$i',
                                style: context.text.labelSmall?.copyWith(
                                  color: i == value
                                      ? activeColor
                                      : context.colors.onSurfaceVariant,
                                  fontWeight: i == value
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          descriptorFor(value),
          style: context.text.labelMedium?.copyWith(color: activeColor),
        ),
      ],
    );
  }
}
