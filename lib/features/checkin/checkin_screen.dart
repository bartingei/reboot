import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import 'checkin_providers.dart';

class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key});

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  final _growthPromptController = TextEditingController();

  @override
  void dispose() {
    _growthPromptController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await ref.read(checkInFormControllerProvider.notifier).submit();
    _growthPromptController.clear();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Check-in saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(checkInFormControllerProvider);
    final controller = ref.read(checkInFormControllerProvider.notifier);
    final recentCheckIns = ref.watch(recentCheckInsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Check-in')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<Pillar>(
            segments: const [
              ButtonSegment(value: Pillar.recovery, label: Text('Recovery')),
              ButtonSegment(value: Pillar.growth, label: Text('Growth')),
            ],
            selected: {form.pillar},
            onSelectionChanged: (selection) =>
                controller.setPillar(selection.first),
          ),
          const SizedBox(height: 24),
          Text('Mood', style: Theme.of(context).textTheme.titleMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (i) {
              final value = i + 1;
              return IconButton(
                iconSize: 32,
                onPressed: () => controller.setMood(value),
                icon: Icon(
                  value <= form.mood
                      ? Icons.sentiment_satisfied
                      : Icons.sentiment_satisfied_outlined,
                  color: value == form.mood
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          if (form.pillar == Pillar.recovery) ...[
            Text('Craving intensity', style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: form.cravingIntensity.toDouble(),
              min: 0,
              max: 10,
              divisions: 10,
              label: '${form.cravingIntensity}',
              onChanged: (value) => controller.setCravingIntensity(value.round()),
            ),
          ] else ...[
            Text('Growth prompt', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _growthPromptController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'What did you work on today?',
                border: OutlineInputBorder(),
              ),
              onChanged: controller.setGrowthPrompt,
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: form.isSubmitting ? null : _submit,
            child: form.isSubmitting
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save check-in'),
          ),
          const SizedBox(height: 32),
          Text('Recent check-ins', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          recentCheckIns.when(
            data: (checkIns) {
              if (checkIns.isEmpty) {
                return const Text('No check-ins yet.');
              }
              return Column(
                children: [
                  for (final checkIn in checkIns)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.check_circle_outline),
                      title: Text('Mood ${checkIn.mood}/5'),
                      subtitle: Text(_formatCheckIn(checkIn)),
                      trailing: Text(_formatTimestamp(checkIn.createdAt)),
                    ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('Failed to load check-ins: $error'),
          ),
        ],
      ),
    );
  }

  String _formatCheckIn(CheckIn checkIn) {
    if (checkIn.cravingIntensity != null) {
      return 'Craving ${checkIn.cravingIntensity}/10';
    }
    if (checkIn.growthPrompt != null && checkIn.growthPrompt!.isNotEmpty) {
      return checkIn.growthPrompt!;
    }
    return '';
  }

  String _formatTimestamp(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.month}/${dt.day} $h:$m';
  }
}
