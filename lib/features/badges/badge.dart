import 'package:flutter/material.dart';

/// A milestone badge, earned once the user's longest-ever check-in streak
/// reaches [thresholdDays]. Earned badges are never lost — the threshold is
/// checked against the best streak in the whole history, not the current one.
class MilestoneBadge {
  const MilestoneBadge({
    required this.thresholdDays,
    required this.label,
    required this.icon,
  });

  final int thresholdDays;
  final String label;
  final IconData icon;
}

/// The badge ladder. Kept deliberately gentle at the start (day one is a
/// real win in recovery) and spaced out further along.
const List<MilestoneBadge> milestoneBadges = [
  MilestoneBadge(thresholdDays: 1, label: 'First step', icon: Icons.eco),
  MilestoneBadge(thresholdDays: 3, label: '3 days', icon: Icons.spa),
  MilestoneBadge(thresholdDays: 7, label: 'One week', icon: Icons.local_florist),
  MilestoneBadge(thresholdDays: 14, label: 'Two weeks', icon: Icons.park),
  MilestoneBadge(thresholdDays: 30, label: 'One month', icon: Icons.wb_sunny),
  MilestoneBadge(thresholdDays: 60, label: 'Two months', icon: Icons.auto_awesome),
  MilestoneBadge(thresholdDays: 90, label: '90 days', icon: Icons.emoji_events),
];

/// Rotating daily affirmations. The Wins screen picks one by day-of-year so
/// it's stable across a day but changes over time.
const List<String> affirmations = [
  'One day at a time.',
  'You are stronger than any craving.',
  'Progress, not perfection.',
  'Every moment is a fresh start.',
  'You showed up today — that matters.',
  'A setback does not erase your progress.',
  'Be proud of how far you have come.',
  'Small steps still move you forward.',
];

String affirmationForDay(DateTime day) {
  final dayOfYear = day.difference(DateTime(day.year)).inDays;
  return affirmations[dayOfYear % affirmations.length];
}
