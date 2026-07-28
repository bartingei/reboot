import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';

/// Craving SOS.
///
/// Renders fully from local state and built-in assets with zero network
/// dependency, and is reachable in one tap from every tab.
///
/// Design rules specific to this screen:
/// - **One thing at once.** The breathing pacer owns the screen; everything
///   else is below the fold. A grid of options is a decision, and decisions
///   are what's expensive in this moment.
/// - **No countdown, no timer, no streak.** Nothing here can be failed.
/// - **Ember, not red; no flashing.** Urgency in the UI adds urgency to the
///   body.
/// - **Distress-sized targets** ([AppTouch.distress]) with plenty of gap —
///   fine motor control is worse when shaking.
/// - **An exit that isn't a trap.** Close is always top-left, always
///   reachable, never confirmed with "are you sure?".
///
/// NOTE: the actions below are wired to stubs — contacts, distraction
/// content, and the crisis-resources screen land in phases 3 and 4.
class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  /// Fades in rather than sliding: a horizontal push reads as "going
  /// deeper into an app", and this should feel like the app stepping aside.
  static Route<void> route() {
    return PageRouteBuilder<void>(
      transitionDuration: AppDuration.slow,
      reverseTransitionDuration: AppDuration.normal,
      pageBuilder: (_, __, ___) => const SosScreen(),
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen>
    with SingleTickerProviderStateMixin {
  /// Box breathing: in 4, hold 4, out 4, hold 4.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDuration.breathPhase * _BreathPhase.values.length,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SOS is always dark, even when the rest of the app is in light mode: a
    // bright screen at 2am is its own small hostility.
    return Theme(
      data: AppTheme.dark(),
      child: Builder(builder: _buildBody),
    );
  }

  Widget _buildBody(BuildContext context) {
    final tokens = context.rebootColors;

    return Scaffold(
      backgroundColor: AppColors.dusk950,
      body: Stack(
        children: [
          // Ember glow behind the pacer, anchored high so the breathing
          // circle sits in it. Purely atmospheric — nothing reads on it.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.45),
                  radius: 0.9,
                  colors: [
                    tokens.sos.withValues(alpha: 0.16),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      iconSize: 28,
                      tooltip: 'Close',
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.gutter,
                      0,
                      AppSpacing.gutter,
                      AppSpacing.xxl,
                    ),
                    children: [
                      Text(
                        "You're here. That's the hard part.",
                        textAlign: TextAlign.center,
                        style: context.text.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                      _BreathingPacer(controller: _controller),
                      const SizedBox(height: AppSpacing.xxxl),
                      Text(
                        'Most cravings peak and fade within twenty minutes. '
                        'Nothing has to be decided until then.',
                        textAlign: TextAlign.center,
                        style: context.text.bodyMedium?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                      _SosAction(
                        icon: Icons.call_outlined,
                        label: 'Call someone',
                        detail: 'Alex · sponsor',
                        onPressed: () {},
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _SosAction(
                        icon: Icons.self_improvement_outlined,
                        label: 'Ground me',
                        detail: '5-4-3-2-1 senses exercise',
                        onPressed: () {},
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _SosAction(
                        icon: Icons.favorite_outline,
                        label: 'Why I started',
                        detail: 'Your own words, from a calmer day',
                        onPressed: () {},
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: context.colors.onSurfaceVariant,
                        ),
                        child: const Text('Crisis helplines'),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'If you are in immediate danger, call your local '
                        'emergency number.',
                        textAlign: TextAlign.center,
                        style: context.text.labelSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _BreathPhase {
  inhale('Breathe in'),
  holdFull('Hold'),
  exhale('Breathe out'),
  holdEmpty('Hold');

  const _BreathPhase(this.label);

  final String label;
}

/// Box-breathing pacer: a circle that expands, holds, contracts, holds.
///
/// The circle is the instruction — the words underneath are a fallback, not
/// the primary channel, because reading is harder than following a shape
/// when you're panicking.
class _BreathingPacer extends StatelessWidget {
  const _BreathingPacer({required this.controller});

  final AnimationController controller;

  static const _size = 240.0;

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;
    // Honour the OS "reduce motion" setting: the phase labels still cycle,
    // but the circle stops pulsing.
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return SizedBox(
      height: _size,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final phases = _BreathPhase.values;
          final position = controller.value * phases.length;
          final index = position.floor().clamp(0, phases.length - 1);
          final phase = phases[index];
          final t = position - index;

          // 0 = smallest, 1 = fullest.
          final fullness = switch (phase) {
            _BreathPhase.inhale => Curves.easeInOut.transform(t),
            _BreathPhase.holdFull => 1.0,
            _BreathPhase.exhale => 1 - Curves.easeInOut.transform(t),
            _BreathPhase.holdEmpty => 0.0,
          };
          final scale = reduceMotion ? 0.85 : 0.55 + 0.45 * fullness;
          final secondsLeft =
              (AppDuration.breathPhase.inSeconds * (1 - t)).ceil();

          return Stack(
            alignment: Alignment.center,
            children: [
              // Static outer guide: shows the full extent of the breath, so
              // the circle always has something to travel toward.
              Container(
                width: _size,
                height: _size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: tokens.sos.withValues(alpha: 0.18),
                  ),
                ),
              ),
              Transform.scale(
                scale: scale,
                child: Container(
                  width: _size,
                  height: _size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tokens.sos.withValues(alpha: 0.12),
                    border: Border.all(
                      color: tokens.sos.withValues(alpha: 0.55),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    phase.label,
                    style: context.text.headlineSmall?.copyWith(
                      color: tokens.sos,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text('$secondsLeft', style: context.text.bodySmall),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SosAction extends StatelessWidget {
  const _SosAction({
    required this.icon,
    required this.label,
    required this.detail,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final String detail;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;

    return Material(
      color: tokens.surfaceRaised,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          constraints: const BoxConstraints(minHeight: AppTouch.distress),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: tokens.hairline),
          ),
          child: Row(
            children: [
              Icon(icon, color: tokens.sos, size: 24),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label, style: context.text.titleMedium),
                    const SizedBox(height: 2),
                    Text(detail, style: context.text.labelSmall),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: context.colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
