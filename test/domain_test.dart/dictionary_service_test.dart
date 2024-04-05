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
      when(() => mockDictionary.value).thenReturn(0);
      when(() => mockDictionary.maxWordLength).thenReturn(10);
      when(() => mockDictionary.lookupText(any()))
          .thenAnswer((_) => Future.value(null));
      when(() => mockDictionary.alphabet)
          .thenReturn('abcdefghijklmnopqrstuvwxyz'.split(''));
    });

    test('filterBy - success', () async {
      // Arrange
      const prefix = 'test';
      final List<Word> filteredWords = [
        const Word(text: 'test', value: 1, state: WordState.accepted)
      ];
      when(() => mockDictionary.isTextTooLong(any())).thenReturn(false);
      when(() => mockDictionary.hasInvalidChar(any())).thenReturn(false);
      when(() => mockWordStorage.query(prefix))
          .thenAnswer((_) async => filteredWords);

      // Act
      final response = await service.filterBy(prefix);

      // Assert
      expect(response.type, equals(ResponseType.success));
      expect(response.value, equals(filteredWords));
    });

    test('filterBy - word too long', () async {
      // Arrange
      const prefix = 'exceptionallylongword';
      when(() => mockDictionary.isTextTooLong(any())).thenReturn(true);
      when(() => mockDictionary.hasInvalidChar(any())).thenReturn(false);

      // Act
      final response = await service.filterBy(prefix);

      // Assert
      expect(response.type, equals(ResponseType.warning));
      expect(response.message,
          equals('The Dictionary cannot store such a long word.'));
    });

    test('saveWords - success', () async {
      // Arrange
      final words = [
        const Word(text: 'testone', value: 1, state: WordState.accepted),
        const Word(text: 'testtwo', value: 2, state: WordState.accepted),
      ];
      when(() => mockDictionary.filterOutRejected(any()))
          .thenAnswer((_) => (accepted: words, rejected: []));

      // Act
      final response = await service.saveWords(words);

      // Assert
      expect(response.type, equals(ResponseType.success));
      verify(() => mockWordStorage.saveAll(words)).called(1);
    });

    test('saveWords - word too long', () async {
      // Arrange
      final words = [
        const Word(
            text: 'exceptionallylongword', value: 1, state: WordState.rejected)
      ];
      when(() => mockDictionary.filterOutRejected(any()))
          .thenAnswer((_) => (accepted: [], rejected: words));

      // Act
      final response = await service.saveWords(words);

      // Assert
      expect(response.type, equals(ResponseType.warning));
      expect(
          response.message, equals('Word(s) were rejected by the dictionary.'));
      verifyNever(() => mockWordStorage.saveAll(words));
    });

    test('saveWords - word with invalid characters', () async {
      // Arrange
      final words = [
        const Word(text: 'test@word', value: 1, state: WordState.rejected)
      ];
      when(() => mockDictionary.filterOutRejected(any()))
          .thenAnswer((_) => (accepted: [], rejected: words));

      // Act
      final response = await service.saveWords(words);

      // Assert
      expect(response.type, equals(ResponseType.warning));
      expect(
          response.message, equals('Word(s) were rejected by the dictionary.'));
      verifyNever(() => mockWordStorage.saveAll(words));
    });

    test('saveWords - word duplicates', () async {
      // Arrange
      final words = [
        const Word(text: 'testone', value: 1, state: WordState.duplicate),
        const Word(text: 'testtwo', value: 2, state: WordState.accepted)
      ];
      when(() => mockDictionary.lookupText(words.first.text))
          .thenAnswer((_) async => words.first);
      when(() => mockDictionary.lookupText(words[1].text))
          .thenAnswer((_) async => null);
      when(() => mockDictionary.filterOutRejected(any()))
          .thenAnswer((_) => (accepted: words, rejected: []));

      // Act
      final response = await service.saveWords(words);

      // Assert
      expect(response.type, equals(ResponseType.success));
      expect(response.value.length, equals(0));
      verify(() => mockWordStorage.saveAll([words[1]])).called(1);
    });

    test('saveWords - warning - returns rejected', () async {
      // Arrange
      final words = [
        const Word(text: 'test1', value: 1, state: WordState.rejected),
        const Word(text: 'testtwo', value: 2, state: WordState.accepted)
      ];
      when(() => mockDictionary.lookupText(words[0].text))
          .thenAnswer((_) async => null);
      when(() => mockDictionary.lookupText(words[1].text))
          .thenAnswer((_) async => null);
      when(() => mockDictionary.filterOutRejected(any()))
          .thenAnswer((_) => (accepted: [words[1]], rejected: [words[0]]));

      // Act
      final response = await service.saveWords(words);

      // Assert
      expect(response.type, equals(ResponseType.warning));
      expect(response.value.length, equals(1));
      expect(response.value.first, equals(words[0]));
      verify(() => mockWordStorage.saveAll([words[1]])).called(1);
    });

    test('saveWords - error', () async {
      // Arrange
      final words = [
        const Word(text: 'test', value: 1, state: WordState.accepted),
        const Word(text: 'testt', value: 2, state: WordState.accepted),
      ];
      when(() => mockDictionary.filterOutRejected(any()))
          .thenAnswer((_) => (accepted: words, rejected: []));
      const errorMessage = 'Error occurred while saving words';
      when(() => mockWordStorage.saveAll(words)).thenThrow(errorMessage);

      // Act
      final response = await service.saveWords(words);

      // Assert
      expect(response.type, equals(ResponseType.error));
      expect(response.message, equals(errorMessage));
    });
  });
}
