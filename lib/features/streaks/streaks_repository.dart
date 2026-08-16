import 'package:drift/drift.dart';

import '../../core/db/app_database.dart';

/// Streams check-in timestamps for a given pillar, joining check-ins to
/// their habit. Streak counts are derived from these in the calculator
/// rather than stored, so they can never drift out of sync with the
/// underlying check-in history.
class StreaksRepository {
  StreaksRepository(this._db);

  final AppDatabase _db;

  Stream<List<DateTime>> watchCheckInDates(Pillar pillar) {
    final query = _db.select(_db.checkIns).join([
      innerJoin(_db.habits, _db.habits.id.equalsExp(_db.checkIns.habitId)),
    ])
      ..where(_db.habits.pillar.equalsValue(pillar));

    return query.watch().map((rows) {
      return rows
          .map((row) => row.readTable(_db.checkIns).createdAt)
          .toList();
    });
  }

  /// Every check-in timestamp across both pillars. Used by the Wins screen
  /// to derive earned badges (longest-ever streak) and the total count.
  Stream<List<DateTime>> watchAllCheckInDates() {
    final query = _db.select(_db.checkIns);
    return query.watch().map((rows) => rows.map((r) => r.createdAt).toList());
  }
}
