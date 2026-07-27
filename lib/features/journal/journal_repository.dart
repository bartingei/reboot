import 'package:drift/drift.dart';

import '../../core/db/app_database.dart';

/// Data access for journal entries. Tags are stored as a comma-separated
/// string in a single column (see the JournalEntries schema); this
/// repository is the one place that encoding is applied and undone, so the
/// rest of the app works with `List<String>` tags.
class JournalRepository {
  JournalRepository(this._db);

  final AppDatabase _db;

  Stream<List<JournalEntry>> watchEntries() {
    final query = _db.select(_db.journalEntries)
      ..orderBy([
        (e) => OrderingTerm(expression: e.createdAt, mode: OrderingMode.desc),
        // id is monotonic, so it breaks ties for entries written in the same
        // clock-second (createdAt is second-precision) — keeps newest first.
        (e) => OrderingTerm(expression: e.id, mode: OrderingMode.desc),
      ]);
    return query.watch();
  }

  Future<void> addEntry({required String body, required List<String> tags}) {
    return _db.into(_db.journalEntries).insert(
          JournalEntriesCompanion.insert(
            body: body,
            tags: Value(encodeTags(tags)),
          ),
        );
  }

  Future<void> deleteEntry(int id) {
    return (_db.delete(_db.journalEntries)..where((e) => e.id.equals(id)))
        .go();
  }

  static String encodeTags(List<String> tags) {
    return tags.map((t) => t.trim()).where((t) => t.isNotEmpty).join(',');
  }

  static List<String> decodeTags(String raw) {
    if (raw.trim().isEmpty) return const [];
    return raw
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
  }
}
