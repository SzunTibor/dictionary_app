// Mock classes
import 'package:dictionary_app_cont/domain/domain_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDictionary extends Mock implements Dictionary {}

class MockWordStorage extends Mock implements WordStorage {}

void main() {
  group('DefaultDictionaryService', () {
    late DefaultDictionaryService service;
    late MockDictionary mockDictionary;
    late MockWordStorage mockWordStorage;

    setUp(() {
      mockDictionary = MockDictionary();
      mockWordStorage = MockWordStorage();
      service = DefaultDictionaryService(dictionary: mockDictionary);
      when(() => mockDictionary.storage).thenReturn(mockWordStorage);
      when(() => mockDictionary.maxWordLength)
          .thenReturn(10); // Stub maxWordLength
      when(() => mockDictionary.alphabet)
          .thenReturn('abcdefghijklmnopqrstuvwxyz'.split('')); // Stub alphabet
    });

    test('filterBy - success', () async {
      const prefix = 'test';
      final List<Word> filteredWords = [const Word(text: 'test', value: 1)];
      when(() => mockWordStorage.query(prefix))
          .thenAnswer((_) async => filteredWords);

      final response = await service.filterBy(prefix);

      expect(response.type, equals(ResponseType.success));
      expect(response.value, equals(filteredWords));
    });

    test('filterBy - word too long', () async {
      const prefix = 'exceptionallylongword';

      final response = await service.filterBy(prefix);

      expect(response.type, equals(ResponseType.warning));
      expect(response.message,
          equals('The Dictionary cannot store such a long word.'));
    });

    test('saveWords - success', () async {
      final words = [
        const Word(text: 'testone', value: 1),
        const Word(text: 'testtwo', value: 2)
      ];

      final response = await service.saveWords(words);

      expect(response.type, equals(ResponseType.success));
      verify(() => mockWordStorage.saveAll(words)).called(1);
    });

    test('saveWords - word too long', () async {
      final words = [const Word(text: 'exceptionallylongword', value: 1)];

      final response = await service.saveWords(words);

      expect(response.type, equals(ResponseType.warning));
      expect(
          response.message, equals('Word(s) were rejected by the dictionary.'));
    });

    test('saveWords - word with invalid characters', () async {
      final words = [const Word(text: 'test@word', value: 1)];

      final response = await service.saveWords(words);

      expect(response.type, equals(ResponseType.warning));
      expect(
          response.message, equals('Word(s) were rejected by the dictionary.'));
    });

    test('saveWords - word duplicates', () async {
      final words = [
        const Word(text: 'testone', value: 1),
        const Word(text: 'testtwo', value: 2)
      ];
      when(() => mockWordStorage.lookup('testone'))
          .thenAnswer((_) async => const Word(text: 'testone', value: 1));

      final response = await service.saveWords(words);

      expect(response.type, equals(ResponseType.success));
      verifyNever(() => mockWordStorage.saveAll(words));
    });

    test('saveWords - error', () async {
      final words = [const Word(text: 'test', value: 1), const Word(text: 'testt', value: 2)];
      const errorMessage = 'Error occurred while saving words';
      when(() => mockWordStorage.saveAll(words)).thenThrow(errorMessage);
      
      final response = await service.saveWords(words);

      expect(response.type, equals(ResponseType.error));
      expect(response.message, equals(errorMessage));
    });
  });
}
