import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get pillar => textEnum<Pillar>()(); // recovery | growth
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class CheckIns extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId => integer().references(Habits, #id)();
  IntColumn get mood => integer()(); // 1-5
  IntColumn get cravingIntensity => integer().nullable()(); // 0-10
  TextColumn get growthPrompt => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get body => text()();
  TextColumn get tags => text().withDefault(const Constant(''))(); // comma-separated
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Streaks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId => integer().references(Habits, #id)();
  IntColumn get currentCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastCheckInAt => dateTime().nullable()();
}

class Milestones extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get unlockedAt => dateTime().withDefault(currentDateAndTime)();
}

enum Pillar { recovery, growth }

@DriftDatabase(tables: [Habits, CheckIns, JournalEntries, Streaks, Milestones])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Opens the database against a caller-provided executor. Used by tests
  /// to run against an in-memory SQLite instance without touching disk.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'reboot.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
