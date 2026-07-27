import 'package:flutter_test/flutter_test.dart';
import 'package:reboot/features/journal/journal_repository.dart';

void main() {
  test('encode joins non-empty trimmed tags', () {
    expect(
      JournalRepository.encodeTags(['  focus ', 'sleep', '']),
      'focus,sleep',
    );
  });

  test('encode of an empty list is an empty string', () {
    expect(JournalRepository.encodeTags([]), '');
  });

  test('decode of an empty string is an empty list', () {
    expect(JournalRepository.decodeTags(''), isEmpty);
    expect(JournalRepository.decodeTags('   '), isEmpty);
  });

  test('decode trims and drops empty segments', () {
    expect(
      JournalRepository.decodeTags(' focus , , sleep '),
      ['focus', 'sleep'],
    );
  });

  test('encode then decode round-trips', () {
    final tags = ['gratitude', 'craving', 'win'];
    expect(
      JournalRepository.decodeTags(JournalRepository.encodeTags(tags)),
      tags,
    );
  });
}
