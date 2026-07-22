import 'package:flutter/material.dart';

/// Craving SOS screen. Must render fully from local state/assets with
/// zero network dependency — reachable in <=2 taps from anywhere in the app.
class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      appBar: AppBar(title: const Text('SOS')),
      body: const Center(
        child: Text('Breathing exercise, distraction tools, call-a-contact, crisis resources'),
      ),
    );
  }
}
