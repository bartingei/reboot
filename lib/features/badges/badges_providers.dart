import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../streaks/streak_calculator.dart';
import '../streaks/streaks_providers.dart';

/// Aggregate progress shown on the Wins screen, derived live from check-in
/// history: the best streak ever reached (which unlocks badges) and the
/// total number of check-ins logged.
class WinsSummary {
  const WinsSummary({required this.longestStreak, required this.totalCheckIns});

  final int longestStreak;
  final int totalCheckIns;
}

final winsSummaryProvider = StreamProvider.autoDispose<WinsSummary>((ref) {
  return ref.watch(streaksRepositoryProvider).watchAllCheckInDates().map(
        (dates) => WinsSummary(
          longestStreak: computeLongestStreak(dates),
          totalCheckIns: dates.length,
        ),
      );
});
