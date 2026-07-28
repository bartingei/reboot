import 'package:flutter/material.dart';

import 'core/theme/app_spacing.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/sos_button.dart';
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
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      // Dark by default rather than following the system: the palette is
      // designed dark-first, and this app is disproportionately opened at
      // night. A setting to follow the system belongs in Settings later.
      themeMode: ThemeMode.dark,
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
    Navigator.of(context).push(SosScreen.route());
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.rebootColors;

    return Scaffold(
      // IndexedStack rather than swapping children: tab state (scroll
      // position, a half-written check-in) survives switching tabs.
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: tokens.surfaceRaised,
          border: Border(top: BorderSide(color: tokens.hairline)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSpacing.md),
              SosButton(onPressed: _openSos),
              NavigationBar(
                selectedIndex: _index,
                onDestinationSelected: (i) => setState(() => _index = i),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.today_outlined),
                    selectedIcon: Icon(Icons.today),
                    label: 'Today',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.add_circle_outline),
                    selectedIcon: Icon(Icons.add_circle),
                    label: 'Check in',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.menu_book_outlined),
                    selectedIcon: Icon(Icons.menu_book),
                    label: 'Journal',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.military_tech_outlined),
                    selectedIcon: Icon(Icons.military_tech),
                    label: 'Wins',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
