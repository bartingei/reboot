import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/pillar_badge.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/streak_ring.dart';

/// Home dashboard ("Today"): both pillars, this week at a glance, and the
/// next milestone.
///
/// The layout answers one question above the fold — *am I on track today* —
/// and everything else is secondary. Nothing here counts down, scolds, or
/// shows a broken streak in red: after a reset the screen shows the new
/// count next to total days logged, which is the number that survives a bad
/// day.
///
/// NOTE: the numbers below are sample data. Streak computation and the
/// providers feeding this screen aren't built yet (ARCHITECTURE.md, phase
/// 2) — this is the presentation layer waiting on them.
class StreaksScreen extends StatelessWidget {
  const StreaksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;
    const data = _DashboardData.sample;

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
            _GreetingHeader(name: data.name),
            const SizedBox(height: AppSpacing.xl),
            const _RecoveryHeroCard(data: data),
            const SizedBox(height: AppSpacing.md),
            const _GrowthCard(data: data),
            const SectionHeader(title: 'This week'),
            _WeekStrip(days: data.week),
            const SectionHeader(title: 'Since you started'),
            Row(
              children: [
                Expanded(
                  child: StatTile(
                    value: '${data.totalDaysLogged}',
                    label: 'days logged',
                    icon: Icons.calendar_today_outlined,
                    accent: tokens.recovery,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: StatTile(
                    value: '${data.checkInCount}',
                    label: 'check-ins',
                    icon: Icons.check_circle_outline,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: StatTile(
                    value: '${data.winCount}',
                    label: 'wins',
                    icon: Icons.military_tech_outlined,
                    accent: tokens.milestone,
                  ),
                ),
              ],
            ),
            const SectionHeader(title: 'Next milestone'),
            const _MilestonePreview(data: data),
          ],
        ),
      ),
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({required this.name});

  final String name;

  static String _greeting(int hour) {
    if (hour < 5) return 'Still up';
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_greeting(now.hour)}, $name',
                style: context.text.displaySmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(_formatToday(now), style: context.text.bodySmall),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          tooltip: 'Settings',
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
    );
  }

  static String _formatToday(DateTime now) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }
}

class _RecoveryHeroCard extends StatelessWidget {
  const _RecoveryHeroCard({required this.data});

  final _DashboardData data;

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;
    final remaining = data.nextMilestoneDays - data.recoveryStreak;

    return AppCard(
      accent: tokens.recovery,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          const PillarBadge(pillar: Pillar.recovery),
          const SizedBox(height: AppSpacing.lg),
          StreakRing(
            days: data.recoveryStreak,
            nextMilestoneDays: data.nextMilestoneDays,
            accent: tokens.recovery,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            remaining > 0
                ? '$remaining days to ${data.nextMilestoneLabel.toLowerCase()}'
                : data.nextMilestoneLabel,
            style: context.text.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (data.checkedInToday)
            _CheckedInPill(accent: tokens.recovery)
          else
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: tokens.recovery,
                foregroundColor: context.colors.onPrimary,
              ),
              child: const Text('Check in for today'),
            ),
        ],
      ),
    );
  }
}

class _CheckedInPill extends StatelessWidget {
  const _CheckedInPill({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        borderRadius: AppRadius.pillBorder,
        border: Border.all(color: accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_rounded, size: 18, color: accent),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Checked in today',
            style: context.text.labelMedium?.copyWith(color: accent),
          ),
        ],
      ),
    );
  }
}

class _GrowthCard extends StatelessWidget {
  const _GrowthCard({required this.data});

  final _DashboardData data;

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;

    return AppCard(
      accent: tokens.growth,
      onTap: () {},
      child: Row(
        children: [
          StreakRing(
            days: data.growthStreak,
            nextMilestoneDays: 7,
            accent: tokens.growth,
            label: 'days',
            size: 76,
            strokeWidth: 7,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PillarBadge(pillar: Pillar.growth, dense: true),
                const SizedBox(height: AppSpacing.sm),
                Text(data.growthFocus, style: context.text.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(data.growthNote, style: context.text.bodySmall),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: context.colors.onSurfaceVariant),
        ],
      ),
    );
  }
}

/// Seven-day check-in history.
///
/// Missed days are a hollow outline, never a red cross — the strip shows the
/// shape of a week, it doesn't mark failures.
class _WeekStrip extends StatelessWidget {
  const _WeekStrip({required this.days});

  final List<_DayStatus> days;

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;

    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final day in days)
            Column(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: day.state == _DayState.logged
                        ? tokens.recovery.withValues(alpha: 0.18)
                        : day.state == _DayState.today
                            ? tokens.surfaceSunken
                            : Colors.transparent,
                    border: Border.all(
                      color: switch (day.state) {
                        _DayState.logged =>
                          tokens.recovery.withValues(alpha: 0.5),
                        _DayState.today => tokens.recovery,
                        _DayState.missed || _DayState.upcoming =>
                          tokens.hairline,
                      },
                      width: day.state == _DayState.today ? 2 : 1,
                    ),
                  ),
                  child: day.state == _DayState.logged
                      ? Icon(
                          Icons.check_rounded,
                          size: 17,
                          color: tokens.recovery,
                        )
                      : Text(
                          '${day.dayOfMonth}',
                          style: day.state == _DayState.today
                              ? context.text.labelMedium
                                  ?.copyWith(color: tokens.recovery)
                              : context.text.labelSmall,
                        ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(day.label, style: context.text.labelSmall),
              ],
            ),
        ],
      ),
    );
  }
}

class _MilestonePreview extends StatelessWidget {
  const _MilestonePreview({required this.data});

  final _DashboardData data;

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;
    final progress =
        (data.recoveryStreak / data.nextMilestoneDays).clamp(0.0, 1.0);

    return AppCard(
      accent: tokens.milestone,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tokens.milestoneSoft,
              border: Border.all(
                color: tokens.milestone.withValues(alpha: 0.4),
              ),
            ),
            child: Icon(
              Icons.workspace_premium_outlined,
              size: 22,
              color: tokens.milestone,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.nextMilestoneLabel, style: context.text.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: tokens.surfaceSunken,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      tokens.milestone,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${data.recoveryStreak} of ${data.nextMilestoneDays} days',
                  style: context.text.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _DayState { logged, missed, today, upcoming }

class _DayStatus {
  const _DayStatus(this.label, this.dayOfMonth, this.state);

  final String label;
  final int dayOfMonth;
  final _DayState state;
}

/// Sample dashboard data. Replace with a Riverpod provider backed by the
/// streak and check-in repositories once phase 2 lands.
class _DashboardData {
  const _DashboardData({
    required this.name,
    required this.recoveryStreak,
    required this.growthStreak,
    required this.nextMilestoneDays,
    required this.nextMilestoneLabel,
    required this.checkedInToday,
    required this.totalDaysLogged,
    required this.checkInCount,
    required this.winCount,
    required this.growthFocus,
    required this.growthNote,
    required this.week,
  });

  final String name;
  final int recoveryStreak;
  final int growthStreak;
  final int nextMilestoneDays;
  final String nextMilestoneLabel;
  final bool checkedInToday;
  final int totalDaysLogged;
  final int checkInCount;
  final int winCount;
  final String growthFocus;
  final String growthNote;
  final List<_DayStatus> week;

  static const sample = _DashboardData(
    name: 'Sam',
    recoveryStreak: 12,
    growthStreak: 4,
    nextMilestoneDays: 14,
    nextMilestoneLabel: 'Two weeks',
    checkedInToday: true,
    totalDaysLogged: 63,
    checkInCount: 48,
    winCount: 5,
    growthFocus: 'Study 30 minutes',
    growthNote: 'Four days running — best stretch yet.',
    week: [
      _DayStatus('M', 21, _DayState.logged),
      _DayStatus('T', 22, _DayState.logged),
      _DayStatus('W', 23, _DayState.missed),
      _DayStatus('T', 24, _DayState.logged),
      _DayStatus('F', 25, _DayState.logged),
      _DayStatus('S', 26, _DayState.logged),
      _DayStatus('S', 27, _DayState.today),
    ],
  );
}
