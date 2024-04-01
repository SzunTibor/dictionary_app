import 'package:dictionary_app_cont/domain/domain_api.dart';
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
      const foundWord = Word(text: 'test', value: 1);
      when(() => mockWordStorage.lookup('test'))
          .thenAnswer((_) async => foundWord);

      final result = await dictionary.lookupText('test');

      expect(result, equals(foundWord));
    });

    test('lookupText - not found', () async {
      when(() => mockWordStorage.lookup('nonexistent'))
          .thenAnswer((_) async => null);

      final result = await dictionary.lookupText('nonexistent');

      expect(result, isNull);
    });

    test('isTextTooLong - true', () {
      const longText = 'exceptionallylongword';

      final result = dictionary.isTextTooLong(longText);

      expect(result, isTrue);
    });

    test('isTextTooLong - false', () {
      const shortText = 'short';

      final result = dictionary.isTextTooLong(shortText);

      expect(result, isFalse);
    });

    test('hasWordInvalidChar - true', () {
      const textWithInvalidChar = 'test@word';

      final result = dictionary.hasInvalidChar(textWithInvalidChar);

      expect(result, isTrue);
    });

    test('hasWordInvalidChar - false', () {
      const validText = 'testword';

      final result = dictionary.hasInvalidChar(validText);

      expect(result, isFalse);
    });
  });
}
