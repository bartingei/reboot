import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'badge.dart';
import 'badges_providers.dart';

class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(winsSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Wins & Badges')),
      body: summary.when(
        data: (data) => _WinsBody(summary: data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load: $error')),
      ),
    );
  }
}

class _WinsBody extends StatelessWidget {
  const _WinsBody({required this.summary});

  final WinsSummary summary;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _AffirmationCard(text: affirmationForDay(DateTime.now())),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _StatTile(
                value: '${summary.longestStreak}',
                label: 'longest streak',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatTile(
                value: '${summary.totalCheckIns}',
                label: 'check-ins',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Badges', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            for (final badge in milestoneBadges)
              _BadgeTile(
                badge: badge,
                unlocked: summary.longestStreak >= badge.thresholdDays,
              ),
          ],
        ),
      ],
    );
  }
}

class _AffirmationCard extends StatelessWidget {
  const _AffirmationCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.favorite, color: scheme.onSecondaryContainer),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: scheme.onSecondaryContainer,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: scheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              label,
              style: TextStyle(color: scheme.onPrimaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.badge, required this.unlocked});

  final MilestoneBadge badge;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = unlocked ? scheme.primary : scheme.outlineVariant;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: unlocked
                ? scheme.primaryContainer
                : scheme.surfaceContainerHighest,
          ),
          child: Icon(
            unlocked ? badge.icon : Icons.lock_outline,
            color: color,
            size: 30,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          badge.label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: unlocked ? null : scheme.outline,
              ),
        ),
      ],
    );
  }
}
