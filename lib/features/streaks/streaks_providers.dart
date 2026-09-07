import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/database_provider.dart';
import 'streak_calculator.dart';
import 'streaks_repository.dart';

final streaksRepositoryProvider = Provider<StreaksRepository>((ref) {
  return StreaksRepository(ref.watch(appDatabaseProvider));
});

/// Live streak count for a single pillar, recomputed whenever a check-in
/// for that pillar is added.
final streakProvider =
    StreamProvider.autoDispose.family<int, Pillar>((ref, pillar) {
  return ref
      .watch(streaksRepositoryProvider)
      .watchCheckInDates(pillar)
      .map(computeStreak);
});
