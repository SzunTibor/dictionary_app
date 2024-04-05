import 'package:dictionary_app_cont/domain/domain_api.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWordStorage extends Mock implements WordStorage {}

void main() {
  group('Dictionary', () {
    late Dictionary dictionary;
    late MockWordStorage mockWordStorage;

    setUp(() {
      mockWordStorage = MockWordStorage();
      dictionary = Dictionary(
          value: 0,
          alphabet: 'abcdefghijklmnopqrstuvwxyz'.split(''),
          joker: '*',
          maxWordLength: 10,
          storage: mockWordStorage);
    });

    test('lookupText - found', () async {
      // Arrange
      const foundWord = Word(text: 'test', value: 1, state: WordState.accepted);
      when(() => mockWordStorage.lookup('test'))
          .thenAnswer((_) async => foundWord);

      // Act
      final result = await dictionary.lookupText('test');

      // Assert
      expect(result, equals(foundWord));
    });

    test('lookupText - not found', () async {
      // Arrange
      when(() => mockWordStorage.lookup('nonexistent'))
          .thenAnswer((_) async => null);

      // Act
      final result = await dictionary.lookupText('nonexistent');

      // Assert
      expect(result, isNull);
    });

    test('isTextTooLong - true', () {
      // Arrange
      const longText = 'exceptionallylongword';

      // Act
      final result = dictionary.isTextTooLong(longText);

      // Assert
      expect(result, isTrue);
    });

    test('isTextTooLong - false', () {
      // Arrange
      const shortText = 'short';

      // Act
      final result = dictionary.isTextTooLong(shortText);

      // Assert
      expect(result, isFalse);
    });

    test('hasWordInvalidChar - true', () {
      // Arrange
      const textWithInvalidChar = 'test@word';

      // Act
      final result = dictionary.hasInvalidChar(textWithInvalidChar);

      expect(result, isTrue);
    });

    test('hasWordInvalidChar - false', () {
      // Arrange
      const validText = 'testword';

      // Act
      final result = dictionary.hasInvalidChar(validText);

      // Assert
      expect(result, isFalse);
    });

    test('filterOutRejected - accept all', () {
      // Arrange
      final words = [
        const Word(text: 'testone', value: 1, state: WordState.accepted),
        const Word(text: 'testtwo', value: 2, state: WordState.accepted),
      ];
      final List<Word> accepted;
      final List<Word> rejected;

      // Act
      (accepted: accepted, rejected: rejected) =
          dictionary.filterOutRejected(words);

      // Assert
      expect(accepted.length, equals(words.length));
      expect(rejected.length, equals(0));
    });

      test('filterOutRejected - reject one', () {
      // Arrange
      final words = [
        const Word(text: 'test1', value: 1, state: WordState.rejected),
        const Word(text: 'testtwo', value: 2, state: WordState.accepted)
      ];
      final List<Word> accepted;
      final List<Word> rejected;

      // Act
      (accepted: accepted, rejected: rejected) =
          dictionary.filterOutRejected(words);

      // Assert
      expect(accepted.length, equals(1));
      expect(rejected.length, equals(1));
      expect(rejected.first.text, equals(words.first.text));
    });
  });
}
