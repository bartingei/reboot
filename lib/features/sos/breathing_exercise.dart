import 'package:flutter/material.dart';

/// Box-breathing guide: inhale 4s, hold 4s, exhale 4s, hold 4s, looping
/// (a 16s cycle). A circle expands on inhale and contracts on exhale so
/// the user can follow with their breath without reading. Fully
/// self-contained — no assets, no network.
class BreathingExercise extends StatefulWidget {
  const BreathingExercise({super.key});

  @override
  State<BreathingExercise> createState() => _BreathingExerciseState();
}

class _BreathingExerciseState extends State<BreathingExercise>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Returns (circleScale 0..1, phase label) for a cycle position t in 0..1.
  (double, String) _phase(double t) {
    if (t < 0.25) return (t / 0.25, 'Breathe in');
    if (t < 0.50) return (1, 'Hold');
    if (t < 0.75) return (1 - (t - 0.50) / 0.25, 'Breathe out');
    return (0, 'Hold');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final (scale, label) = _phase(_controller.value);
        final size = 120 + scale * 100;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 240,
              child: Center(
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.primary.withValues(alpha: 0.25),
                    border: Border.all(color: scheme.primary, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(label, style: Theme.of(context).textTheme.headlineSmall),
          ],
        );
      },
    );
  }
}
