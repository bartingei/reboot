import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/section_header.dart';

/// Journal.
///
/// Entries are grouped by day and shown in full-ish preview rather than as
/// one-line list tiles — the value of a journal is re-reading it, and a
/// stack of truncated titles doesn't invite that. Tags are optional and
/// suggested, never required.
///
/// NOTE: entries below are sample data. The journal repository and its
/// providers aren't built yet (ARCHITECTURE.md, phase 2).
class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  String _activeTag = _JournalEntry.allTag;

  List<_JournalEntry> get _visibleEntries {
    if (_activeTag == _JournalEntry.allTag) return _JournalEntry.samples;
    return _JournalEntry.samples
        .where((entry) => entry.tags.contains(_activeTag))
        .toList();
  }

  void _openComposer() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _ComposerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = _visibleEntries;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openComposer,
        backgroundColor: context.colors.primaryContainer,
        foregroundColor: context.colors.onPrimaryContainer,
        elevation: 0,
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Write'),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.sm,
            AppSpacing.gutter,
            AppSpacing.scrollBottom,
          ),
          children: [
            Text('Journal', style: context.text.displaySmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${_JournalEntry.samples.length} entries, all on this device',
              style: context.text.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            _TagFilterRow(
              active: _activeTag,
              onSelected: (tag) => setState(() => _activeTag = tag),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (entries.isEmpty)
              const EmptyState(
                icon: Icons.menu_book_outlined,
                message: 'Nothing tagged this way yet.',
              )
            else
              for (final entry in entries) ...[
                _EntryCard(entry: entry),
                const SizedBox(height: AppSpacing.md),
              ],
            const SectionHeader(title: 'Prompt for today'),
            const _PromptCard(
              prompt: 'What was one moment today you handled better than you '
                  'would have a month ago?',
            ),
          ],
        ),
      ),
    );
  }
}

class _TagFilterRow extends StatelessWidget {
  const _TagFilterRow({required this.active, required this.onSelected});

  final String active;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _JournalEntry.knownTags.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final tag = _JournalEntry.knownTags[index];
          final selected = tag == active;
          return GestureDetector(
            onTap: () => onSelected(tag),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? context.colors.primaryContainer
                    : tokens.surfaceSunken,
                borderRadius: AppRadius.pillBorder,
                border: Border.all(
                  color: selected
                      ? context.colors.primary.withValues(alpha: 0.5)
                      : tokens.hairline,
                ),
              ),
              child: Text(
                tag,
                style: context.text.labelMedium?.copyWith(
                  color: selected
                      ? context.colors.onPrimaryContainer
                      : context.colors.onSurfaceVariant,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry});

  final _JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;

    return AppCard(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(entry.dayLabel, style: context.text.titleSmall),
              const SizedBox(width: AppSpacing.sm),
              Text('· ${entry.timeLabel}', style: context.text.labelSmall),
              const Spacer(),
              Icon(
                Icons.circle,
                size: 8,
                color: entry.calm ? tokens.recovery : tokens.sos,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            entry.body,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: context.text.bodyLarge,
          ),
          if (entry.tags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final tag in entry.tags)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: tokens.surfaceSunken,
                      borderRadius: AppRadius.pillBorder,
                      border: Border.all(color: tokens.hairline),
                    ),
                    child: Text(tag, style: context.text.labelSmall),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({required this.prompt});

  final String prompt;

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;

    return AppCard(
      accent: tokens.growth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.format_quote_rounded, color: tokens.growth),
          const SizedBox(height: AppSpacing.sm),
          Text(prompt, style: context.text.bodyLarge),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: tokens.growth,
              side: BorderSide(color: tokens.growth.withValues(alpha: 0.5)),
            ),
            child: const Text('Answer this'),
          ),
        ],
      ),
    );
  }
}

/// Composer sheet. Deliberately a sheet rather than a full page: writing a
/// line and dismissing should feel as cheap as sending a text.
class _ComposerSheet extends StatelessWidget {
  const _ComposerSheet();

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.viewInsetsOf(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        0,
        AppSpacing.gutter,
        AppSpacing.gutter + insets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('New entry', style: context.text.titleLarge),
          const SizedBox(height: AppSpacing.lg),
          const TextField(
            autofocus: true,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'No one else reads this.',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final tag in _JournalEntry.suggestedTags)
                ActionChip(label: Text(tag), onPressed: () {}),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Save entry'),
          ),
        ],
      ),
    );
  }
}

/// Sample journal data. Replace with a repository-backed provider.
class _JournalEntry {
  const _JournalEntry({
    required this.dayLabel,
    required this.timeLabel,
    required this.body,
    required this.tags,
    required this.calm,
  });

  final String dayLabel;
  final String timeLabel;
  final String body;
  final List<String> tags;

  /// Whether the entry was logged on a low-craving day — drives the dot in
  /// the corner, which is the only affect indicator on the card.
  final bool calm;

  static const allTag = 'All';

  static const knownTags = [
    allTag,
    'trigger',
    'win',
    'gratitude',
    'therapy',
  ];

  static const suggestedTags = ['trigger', 'win', 'gratitude'];

  static const samples = [
    _JournalEntry(
      dayLabel: 'Today',
      timeLabel: '21:40',
      body: 'Nearly went out with the old crowd. Called my sister instead and '
          'we talked for an hour about nothing. Craving passed in about '
          'twenty minutes, which is faster than last week.',
      tags: ['trigger', 'win'],
      calm: true,
    ),
    _JournalEntry(
      dayLabel: 'Yesterday',
      timeLabel: '07:15',
      body: 'Woke up early without the alarm for the first time in months. '
          'Sat with coffee and did nothing. That used to feel like wasted '
          'time.',
      tags: ['gratitude'],
      calm: true,
    ),
    _JournalEntry(
      dayLabel: 'Saturday',
      timeLabel: '23:02',
      body: 'Hard night. Wrote this instead of doing anything about it, which '
          'I am counting as the win.',
      tags: ['trigger'],
      calm: false,
    ),
  ];
}
