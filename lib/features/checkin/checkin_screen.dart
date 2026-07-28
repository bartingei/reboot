import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/intensity_scale.dart';
import '../../core/widgets/mood_selector.dart';
import '../../core/widgets/pillar_badge.dart';
import '../../core/widgets/section_header.dart';

/// Daily check-in.
///
/// One screen, no wizard: the whole form is visible at once so a check-in
/// costs a few taps, not a flow. Everything except the pillar toggle has a
/// sensible default, so "save" is always a valid action — a half-answered
/// check-in is still worth more than a skipped one.
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

    final tokens = context.rebootColors;
    final isRecovery = form.pillar == Pillar.recovery;
    final accent = tokens.pillar(isRecovery: isRecovery);

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
            Text('How was today?', style: context.text.displaySmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Takes about twenty seconds. Nothing leaves your phone.',
              style: context.text.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xl),
            SegmentedButton<Pillar>(
              segments: [
                ButtonSegment(
                  value: Pillar.recovery,
                  label: const Text('Recovery'),
                  icon: Icon(PillarBadge.iconFor(Pillar.recovery), size: 18),
                ),
                ButtonSegment(
                  value: Pillar.growth,
                  label: const Text('Growth'),
                  icon: Icon(PillarBadge.iconFor(Pillar.growth), size: 18),
                ),
              ],
              selected: {form.pillar},
              showSelectedIcon: false,
              onSelectionChanged: (selection) =>
                  controller.setPillar(selection.first),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppCard(
              accent: accent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel(
                    'Mood',
                    hint: MoodSelector.labelFor(form.mood),
                    accent: accent,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  MoodSelector(
                    value: form.mood,
                    onChanged: controller.setMood,
                    accent: accent,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  // The second field is the one that differs by pillar:
                  // recovery tracks craving pressure, growth captures what
                  // the user actually did.
                  if (isRecovery) ...[
                    _FieldLabel(
                      'Craving intensity',
                      hint: '${form.cravingIntensity}/10',
                      accent: tokens.cravingColor(form.cravingIntensity),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    IntensityScale(
                      value: form.cravingIntensity,
                      onChanged: controller.setCravingIntensity,
                    ),
                  ] else ...[
                    _FieldLabel('What did you work on?', accent: accent),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: _growthPromptController,
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Even a small thing counts.',
                      ),
                      onChanged: controller.setGrowthPrompt,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: form.isSubmitting ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: context.colors.onPrimary,
              ),
              child: form.isSubmitting
                  ? SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.colors.onPrimary,
                      ),
                    )
                  : const Text('Save check-in'),
            ),
            const SectionHeader(title: 'Recent check-ins'),
            recentCheckIns.when(
              data: (checkIns) {
                if (checkIns.isEmpty) {
                  return const EmptyState(
                    icon: Icons.history_toggle_off,
                    message:
                        'Your check-ins will show up here.\nThe first one is '
                        'the hardest.',
                  );
                }
                return Column(
                  children: [
                    for (final checkIn in checkIns) ...[
                      _CheckInRow(checkIn: checkIn),
                      if (checkIn != checkIns.last)
                        const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(AppSpacing.xxl),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => EmptyState(
                icon: Icons.error_outline,
                message: "Couldn't load your check-ins.\n$error",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label, {this.hint, required this.accent});

  final String label;
  final String? hint;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: context.text.titleMedium)),
        if (hint != null)
          Text(
            hint!,
            style: context.text.labelMedium?.copyWith(color: accent),
          ),
      ],
    );
  }
}

class _CheckInRow extends StatelessWidget {
  const _CheckInRow({required this.checkIn});

  final CheckIn checkIn;

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;
    final isRecovery = checkIn.cravingIntensity != null;
    final accent = tokens.pillar(isRecovery: isRecovery);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tokens.pillarSoft(isRecovery: isRecovery),
            ),
            child: Icon(_moodIcon(checkIn.mood), size: 20, color: accent),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  MoodSelector.labelFor(checkIn.mood),
                  style: context.text.titleSmall,
                ),
                if (_detail(checkIn) case final detail?) ...[
                  const SizedBox(height: 2),
                  Text(
                    detail,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            _formatTimestamp(checkIn.createdAt),
            style: context.text.labelSmall,
          ),
        ],
      ),
    );
  }

  static IconData _moodIcon(int mood) => switch (mood) {
        1 => Icons.sentiment_very_dissatisfied,
        2 => Icons.sentiment_dissatisfied,
        3 => Icons.sentiment_neutral,
        4 => Icons.sentiment_satisfied,
        _ => Icons.sentiment_very_satisfied,
      };

  static String? _detail(CheckIn checkIn) {
    final craving = checkIn.cravingIntensity;
    if (craving != null) {
      return 'Craving ${IntensityScale.descriptorFor(craving).toLowerCase()} '
          '($craving/10)';
    }
    final prompt = checkIn.growthPrompt;
    if (prompt != null && prompt.isNotEmpty) return prompt;
    return null;
  }

  static String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final isToday = dt.year == now.year &&
        dt.month == now.month &&
        dt.day == now.day;
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    if (isToday) return '$h:$m';
    return '${dt.day}/${dt.month}';
  }
}
