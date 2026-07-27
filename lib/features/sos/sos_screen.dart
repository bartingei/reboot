import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'breathing_exercise.dart';
import 'grounding_exercise.dart';
import 'sos_resources.dart';

/// Craving SOS screen. Must render fully from local state/assets with
/// zero network dependency — reachable in <=2 taps from anywhere in the
/// app (persistent FAB in the app shell). See ARCHITECTURE.md.
class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = defaultSosContacts;
    final hasExamples = contacts.any((c) => c.isExample);

    return Scaffold(
      appBar: AppBar(title: const Text('You\'ve got this')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'This will pass. Take it one breath at a time.',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const _Section(
            title: 'Breathe',
            child: BreathingExercise(),
          ),
          const _Section(
            title: 'Ground yourself',
            child: GroundingExercise(),
          ),
          _Section(
            title: 'Reach out',
            child: Column(
              children: [
                if (hasExamples) const _ResourcesDisclaimer(),
                for (final contact in contacts)
                  _ContactTile(contact: contact),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _ResourcesDisclaimer extends StatelessWidget {
  const _ResourcesDisclaimer();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber, color: scheme.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'These are placeholder numbers. Set verified local crisis '
              'and emergency contacts before relying on them.',
              style: TextStyle(color: scheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.contact});

  final SosContact contact;

  Future<void> _call(BuildContext context) async {
    final uri = Uri(scheme: 'tel', path: contact.phone);
    final launched = await launchUrl(uri);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not start a call to ${contact.phone}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasNumber = contact.phone.trim().isNotEmpty;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.phone),
      title: Text(contact.label),
      subtitle: contact.description != null ? Text(contact.description!) : null,
      trailing: hasNumber
          ? FilledButton(
              onPressed: () => _call(context),
              child: Text('Call ${contact.phone}'),
            )
          : const Text('Not set'),
    );
  }
}
