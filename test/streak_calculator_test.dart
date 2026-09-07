import 'package:flutter_test/flutter_test.dart';
import 'package:reboot/features/streaks/streak_calculator.dart';

void main() {
  final now = DateTime(2026, 7, 22, 10, 0);

  test('empty history is a zero streak', () {
    expect(computeStreak([], now: now), 0);
  });

  test('single check-in today is a one-day streak', () {
    expect(computeStreak([DateTime(2026, 7, 22, 8)], now: now), 1);
  });

  test('consecutive days ending today count fully', () {
    final times = [
      DateTime(2026, 7, 22, 8),
      DateTime(2026, 7, 21, 9),
      DateTime(2026, 7, 20, 12),
    ];
    expect(computeStreak(times, now: now), 3);
  });

  test('multiple check-ins on the same day count once', () {
    final times = [
      DateTime(2026, 7, 22, 8),
      DateTime(2026, 7, 22, 20),
      DateTime(2026, 7, 21, 9),
    ];
    expect(computeStreak(times, now: now), 2);
  });

  test('streak survives when latest check-in was yesterday', () {
    final times = [
      DateTime(2026, 7, 21, 9),
      DateTime(2026, 7, 20, 9),
    ];
    expect(computeStreak(times, now: now), 2);
  });

  test('a two-day gap breaks the streak to zero', () {
    final times = [DateTime(2026, 7, 19, 9)];
    expect(computeStreak(times, now: now), 0);
  });

  test('only the current run counts, earlier runs are ignored', () {
    final times = [
      DateTime(2026, 7, 22, 8),
      DateTime(2026, 7, 21, 8),
      // gap on the 20th
      DateTime(2026, 7, 19, 8),
      DateTime(2026, 7, 18, 8),
    ];
    expect(computeStreak(times, now: now), 2);
  });
}
