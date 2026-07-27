import 'package:drift/drift.dart';

import '../../core/db/app_database.dart';

/// Data access for check-ins. Habit management (creating/renaming/deleting
/// habits) isn't built yet, so this repository seeds one default habit per
/// pillar on first use rather than requiring a habit-picker up front.
class CheckInRepository {
  CheckInRepository(this._db);

  final AppDatabase _db;

  Future<Habit> ensureDefaultHabit(Pillar pillar) async {
    final habits = await _db.select(_db.habits).get();
    for (final habit in habits) {
      if (habit.pillar == pillar) return habit;
    }

    final name = pillar == Pillar.recovery ? 'Recovery' : 'Growth';
    final id = await _db.into(_db.habits).insert(
          HabitsCompanion.insert(name: name, pillar: pillar),
        );
    return (_db.select(_db.habits)..where((h) => h.id.equals(id)))
        .getSingle();
  }

  Future<void> addCheckIn({
    required int habitId,
    required int mood,
    int? cravingIntensity,
    String? growthPrompt,
  }) {
    return _db.into(_db.checkIns).insert(
          CheckInsCompanion.insert(
            habitId: habitId,
            mood: mood,
            cravingIntensity: Value(cravingIntensity),
            growthPrompt: Value(growthPrompt),
          ),
        );
  }

  Stream<List<CheckIn>> watchRecentCheckIns({int limit = 10}) {
    final query = _db.select(_db.checkIns)
      ..orderBy([
        (c) => OrderingTerm(expression: c.createdAt, mode: OrderingMode.desc),
        // id tiebreaker: createdAt is second-precision, so several check-ins
        // in the same second would otherwise order non-deterministically.
        (c) => OrderingTerm(expression: c.id, mode: OrderingMode.desc),
      ])
      ..limit(limit);
    return query.watch();
  }
}
