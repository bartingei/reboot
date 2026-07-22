import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/database_provider.dart';
import 'journal_repository.dart';

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepository(ref.watch(appDatabaseProvider));
});

final journalEntriesProvider =
    StreamProvider.autoDispose<List<JournalEntry>>((ref) {
  return ref.watch(journalRepositoryProvider).watchEntries();
});
