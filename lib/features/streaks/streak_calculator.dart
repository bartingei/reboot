/// Computes a check-in streak: the number of consecutive days up to and
/// including today (or yesterday) that have at least one check-in.
///
/// The streak stays alive if the most recent check-in was today or
/// yesterday; a gap of a full calendar day breaks it. Multiple check-ins
/// on the same day count once. Computed client-side — see ARCHITECTURE.md
/// for why streaks are client-trusted rather than server-validated.
int computeStreak(List<DateTime> checkInTimes, {DateTime? now}) {
  if (checkInTimes.isEmpty) return 0;

  final today = _dateOnly(now ?? DateTime.now());

  final days = checkInTimes.map(_dateOnly).toSet();

  // The streak can only be current if there's a check-in today or yesterday.
  var cursor = today;
  if (!days.contains(cursor)) {
    cursor = today.subtract(const Duration(days: 1));
    if (!days.contains(cursor)) return 0;
  }

  var streak = 0;
  while (days.contains(cursor)) {
    streak++;
    cursor = cursor.subtract(const Duration(days: 1));
  }
  return streak;
}

DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

/// The longest run of consecutive days with at least one check-in, anywhere
/// in the history. Unlike [computeStreak] this looks at the whole record,
/// so a badge earned from a past streak stays earned even after a setback —
/// which matters for a recovery app.
int computeLongestStreak(List<DateTime> checkInTimes) {
  if (checkInTimes.isEmpty) return 0;

  final days = checkInTimes.map(_dateOnly).toSet();
  var longest = 0;

  for (final day in days) {
    // Only start counting at the beginning of a run.
    if (days.contains(day.subtract(const Duration(days: 1)))) continue;
    var cursor = day;
    var run = 0;
    while (days.contains(cursor)) {
      run++;
      cursor = cursor.add(const Duration(days: 1));
    }
    if (run > longest) longest = run;
  }
  return longest;
}
