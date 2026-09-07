import 'package:flutter/material.dart';

/// The 5-4-3-2-1 grounding technique: name things you can sense, stepping
/// down from five to one. A simple distraction/refocus tool for riding out
/// a craving or spike of distress.
class GroundingExercise extends StatelessWidget {
  const GroundingExercise({super.key});

  static const _steps = [
    (5, 'things you can see'),
    (4, 'things you can feel'),
    (3, 'things you can hear'),
    (2, 'things you can smell'),
    (1, 'thing you can taste'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (count, what) in _steps)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  child: Text('$count'),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(what)),
              ],
            ),
          ),
      ],
    );
  }
}
