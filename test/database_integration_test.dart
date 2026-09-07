import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reboot/core/db/app_database.dart';
import 'package:reboot/features/checkin/checkin_repository.dart';
import 'package:reboot/features/journal/journal_repository.dart';

/// End-to-end exercise of the real Drift schema and repositories against an
/// in-memory SQLite database — proves the data layer actually runs, not just
/// that it compiles.
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('check-in flow persists and reads back a recovery check-in', () async {
    final repo = CheckInRepository(db);

    final habit = await repo.ensureDefaultHabit(Pillar.recovery);
    expect(habit.pillar, Pillar.recovery);

    // ensureDefaultHabit is idempotent — no duplicate habit on second call.
    final again = await repo.ensureDefaultHabit(Pillar.recovery);
    expect(again.id, habit.id);

    await repo.addCheckIn(
      habitId: habit.id,
      mood: 4,
      cravingIntensity: 7,
    );

    final recent = await repo.watchRecentCheckIns().first;
    expect(recent, hasLength(1));
    expect(recent.single.mood, 4);
    expect(recent.single.cravingIntensity, 7);
  });

  test('journal flow persists entries with tags and deletes them', () async {
    final repo = JournalRepository(db);

    await repo.addEntry(body: 'first entry', tags: ['gratitude', 'win']);
    await repo.addEntry(body: 'second entry', tags: []);

    var entries = await repo.watchEntries().first;
    expect(entries, hasLength(2));
    // Newest first.
    expect(entries.first.body, 'second entry');
    expect(JournalRepository.decodeTags(entries.last.tags),
        ['gratitude', 'win']);

    await repo.deleteEntry(entries.first.id);
    entries = await repo.watchEntries().first;
    expect(entries, hasLength(1));
    expect(entries.single.body, 'first entry');
  });
}
