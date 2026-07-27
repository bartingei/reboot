import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'journal_providers.dart';
import 'journal_repository.dart';

/// Create a new journal entry. Kept as a separate route so the write
/// surface is deliberate — reflecting is a distinct act from browsing.
class JournalEditorScreen extends ConsumerStatefulWidget {
  const JournalEditorScreen({super.key});

  @override
  ConsumerState<JournalEditorScreen> createState() =>
      _JournalEditorScreenState();
}

class _JournalEditorScreenState extends ConsumerState<JournalEditorScreen> {
  final _bodyController = TextEditingController();
  final _tagsController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _bodyController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final body = _bodyController.text.trim();
    if (body.isEmpty) return;

    setState(() => _saving = true);
    await ref.read(journalRepositoryProvider).addEntry(
          body: body,
          tags: JournalRepository.decodeTags(_tagsController.text),
        );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final canSave = _bodyController.text.trim().isNotEmpty && !_saving;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New entry'),
        actions: [
          TextButton(
            onPressed: canSave ? _save : null,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TextField(
                controller: _bodyController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags',
                hintText: 'comma, separated',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
