import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/section_header.dart';

/// Wins & badges.
///
/// Two kinds of thing live here: milestones the app awards automatically
/// (time-based, unambiguous) and wins the user logs themselves. The second
/// list matters more — self-logged wins are the ones that hold up on a day
/// when the streak has just reset, and they're the reason this screen isn't
/// only a trophy case.
///
/// Locked badges are shown, but greyed and without a countdown. Seeing what
/// is ahead is motivating; a ticking timer to it is pressure.
///
/// NOTE: sample data — the milestone repository isn't built yet
/// (ARCHITECTURE.md, phase 3).
class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;
    final earned = _Badge.samples.where((b) => b.earned).length;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.sm,
            AppSpacing.gutter,
            AppSpacing.xxl,
          ),
          children: [
            Text('Wins', style: context.text.displaySmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '$earned of ${_Badge.samples.length} milestones reached',
              style: context.text.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xl),
            const _LatestWinCard(),
            const SectionHeader(title: 'Milestones'),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.85,
              children: [
                for (final badge in _Badge.samples) _BadgeTile(badge: badge),
              ],
            ),
            SectionHeader(
              title: 'Your wins',
              actionLabel: 'Log a win',
              onAction: () {},
            ),
            for (final win in _LoggedWin.samples) ...[
              _WinRow(win: win),
              const SizedBox(height: AppSpacing.sm),
            ],
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              accent: tokens.recovery,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'A reset does not delete any of this.',
                    style: context.text.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Badges you have earned and wins you have logged stay '
                    'earned. Only the current streak count starts over.',
                    style: context.text.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LatestWinCard extends StatelessWidget {
  const _LatestWinCard();

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;

    return AppCard(
      accent: tokens.milestone,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tokens.milestoneSoft,
              border: Border.all(
                color: tokens.milestone.withValues(alpha: 0.45),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.workspace_premium,
              size: 34,
              color: tokens.milestone,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('One week', style: context.text.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Earned 5 days ago',
            style: context.text.labelMedium?.copyWith(
              color: tokens.milestone,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Seven days of check-ins, including two you nearly skipped.',
            textAlign: TextAlign.center,
            style: context.text.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.badge});

  final _Badge badge;

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;
    final color =
        badge.earned ? tokens.milestone : context.colors.onSurfaceVariant;

    return Opacity(
      opacity: badge.earned ? 1 : 0.45,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.lg,
          horizontal: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: badge.earned ? tokens.milestoneSoft : tokens.surfaceSunken,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: badge.earned
                ? tokens.milestone.withValues(alpha: 0.35)
                : tokens.hairline,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              badge.earned ? badge.icon : Icons.lock_outline,
              size: 26,
              color: color,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              badge.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.text.labelMedium?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _WinRow extends StatelessWidget {
  const _WinRow({required this.win});

  final _LoggedWin win;

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.star_rounded, size: 20, color: tokens.milestone),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(win.text, style: context.text.bodyMedium),
                const SizedBox(height: 2),
                Text(win.when, style: context.text.labelSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge {
  const _Badge(this.label, this.icon, {required this.earned});

  final String label;
  final IconData icon;
  final bool earned;

  static const samples = [
    _Badge('First day', Icons.flag_outlined, earned: true),
    _Badge('3 days', Icons.filter_3, earned: true),
    _Badge('One week', Icons.workspace_premium, earned: true),
    _Badge('Two weeks', Icons.shield_moon_outlined, earned: false),
    _Badge('One month', Icons.calendar_month_outlined, earned: false),
    _Badge('90 days', Icons.landscape_outlined, earned: false),
  ];
}

class _LoggedWin {
  const _LoggedWin(this.text, this.when);

  final String text;
  final String when;

  static const samples = [
    _LoggedWin('Told a friend what I am working on.', 'Yesterday'),
    _LoggedWin('Went to the gym instead of the pub on Friday.', '3 days ago'),
    _LoggedWin('Slept through the night twice this week.', 'Last week'),
  ];
}
