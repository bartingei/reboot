import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';

/// The signature component: a streak count inside a progress ring showing
/// how far along the user is toward their next milestone.
///
/// The ring is progress toward the *next* milestone rather than an absolute
/// scale, so a day-3 streak still shows visible movement — an early streak
/// rendered as a 1% sliver is discouraging at exactly the moment it matters.
class StreakRing extends StatelessWidget {
  const StreakRing({
    super.key,
    required this.days,
    required this.nextMilestoneDays,
    required this.accent,
    this.label = 'day streak',
    this.size = 168,
    this.strokeWidth = 12,
  });

  /// Current streak length in days.
  final int days;

  /// Day count of the next milestone. The ring fills as [days] approaches it.
  final int nextMilestoneDays;

  final Color accent;
  final String label;
  final double size;
  final double strokeWidth;

  double get _progress {
    if (nextMilestoneDays <= 0) return 1;
    return (days / nextMilestoneDays).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;

    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: _progress),
        duration: AppDuration.slow,
        curve: Curves.easeOutCubic,
        builder: (context, value, _) {
          return CustomPaint(
            painter: _StreakRingPainter(
              progress: value,
              accent: accent,
              track: tokens.surfaceSunken,
              strokeWidth: strokeWidth,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$days',
                    style: context.text.displaySmall?.merge(
                      TextStyle(fontSize: size * 0.3, color: accent),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: context.text.labelSmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StreakRingPainter extends CustomPainter {
  _StreakRingPainter({
    required this.progress,
    required this.accent,
    required this.track,
    required this.strokeWidth,
  });

  final double progress;
  final Color accent;
  final Color track;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    // Sweep clockwise from 12 o'clock. The gradient darkens slightly toward
    // the head of the arc so the leading edge reads as "the current day".
    const startAngle = -math.pi / 2;
    final sweep = 2 * math.pi * progress;
    final arcRect = Rect.fromCircle(center: center, radius: radius);

    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * math.pi,
        transform: const GradientRotation(startAngle),
        colors: [
          accent.withValues(alpha: 0.55),
          accent,
          accent,
        ],
        stops: const [0.0, 0.65, 1.0],
      ).createShader(arcRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(arcRect, startAngle, sweep, false, progressPaint);
  }

  @override
  bool shouldRepaint(_StreakRingPainter old) =>
      old.progress != progress ||
      old.accent != accent ||
      old.track != track ||
      old.strokeWidth != strokeWidth;
}
