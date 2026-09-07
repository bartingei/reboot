import 'package:flutter_test/flutter_test.dart';
import 'package:reboot/features/streaks/streak_calculator.dart';

void main() {
  DateTime d(int day) => DateTime(2026, 1, day);

  test('empty history has no streak', () {
    expect(computeLongestStreak([]), 0);
  });

  test('single check-in is a one-day streak', () {
    expect(computeLongestStreak([d(5)]), 1);
  });

  test('finds the longest run, not the most recent', () {
    // A 4-day run (1-4), a gap, then a 2-day run (10-11).
    final times = [d(1), d(2), d(3), d(4), d(10), d(11)];
    expect(computeLongestStreak(times), 4);
  });

  test('same-day check-ins do not inflate the streak', () {
    final times = [d(1), d(1), d(2), d(2), d(2)];
    expect(computeLongestStreak(times), 2);
  });

  test('unordered input is handled', () {
    final times = [d(11), d(2), d(10), d(1), d(4), d(3)];
    expect(computeLongestStreak(times), 4);
  });

  test('badge stays earned: longest run counts even after a later gap', () {
    // 7-day run early, then only sporadic single days later.
    final times = [
      for (var i = 1; i <= 7; i++) d(i),
      d(20),
      d(25),
    ];
    expect(computeLongestStreak(times), 7);
  });
}
