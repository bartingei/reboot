import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import 'streaks_providers.dart';

/// Home dashboard: shows both the recovery and growth pillars side by side.
class StreaksScreen extends ConsumerWidget {
  const StreaksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Expanded(
              child: _PillarCard(
                pillar: Pillar.recovery,
                label: 'Recovery',
                icon: Icons.self_improvement,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _PillarCard(
                pillar: Pillar.growth,
                label: 'Growth',
                icon: Icons.trending_up,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PillarCard extends ConsumerWidget {
  const _PillarCard({
    required this.pillar,
    required this.label,
    required this.icon,
  });

  final Pillar pillar;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider(pillar));
    final scheme = Theme.of(context).colorScheme;

    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: scheme.onPrimaryContainer),
            const SizedBox(height: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: scheme.onPrimaryContainer,
                  ),
            ),
            const SizedBox(height: 8),
            streak.when(
              data: (days) => _StreakCount(days: days),
              loading: () => const SizedBox(
                height: 48,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => Text('Error: $error'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakCount extends StatelessWidget {
  const _StreakCount({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          '$days',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: scheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          'day streak',
          style: TextStyle(color: scheme.onPrimaryContainer),
        ),
      ],
    );
  }
}
