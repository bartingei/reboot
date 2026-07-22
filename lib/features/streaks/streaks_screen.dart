import 'package:flutter/material.dart';

/// Home dashboard: shows both the recovery and growth pillars side by side.
class StreaksScreen extends StatelessWidget {
  const StreaksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Recovery + growth streak dashboard')),
    );
  }
}
