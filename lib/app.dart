import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/badges/badges_screen.dart';
import 'features/checkin/checkin_screen.dart';
import 'features/journal/journal_screen.dart';
import 'features/sos/sos_screen.dart';
import 'features/streaks/streaks_screen.dart';

class RebootApp extends StatelessWidget {
  const RebootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'reboot',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _screens = [
    StreaksScreen(),
    CheckInScreen(),
    JournalScreen(),
    BadgesScreen(),
  ];

  void _openSos() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SosScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openSos,
        backgroundColor: Theme.of(context).colorScheme.error,
        icon: const Icon(Icons.sos),
        label: const Text('SOS'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.check_circle), label: 'Check-in'),
          NavigationDestination(icon: Icon(Icons.book), label: 'Journal'),
          NavigationDestination(icon: Icon(Icons.emoji_events), label: 'Wins'),
        ],
      ),
    );
  }
}
