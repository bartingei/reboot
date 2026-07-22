import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// Shared database instance, closed when the provider container disposes.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
