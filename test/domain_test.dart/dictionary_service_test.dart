import 'package:dictionary_app_cont/data/word_storage/word_storage.dart';
import 'package:dictionary_app_cont/domain/dicionary_service/english_dictionary_service.dart';
import 'package:dictionary_app_cont/domain/models/word.dart';
import 'package:dictionary_app_cont/domain/response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockWordStorage extends Mock implements WordStorage {}

void main() {
  group('EnglishDictionaryService', () {
    late EnglishDictionaryService service;
    late MockWordStorage mockWordStorage;

    setUp(() {
      // Initialize mock objects
      mockWordStorage = MockWordStorage();
      // Initialize the service instance with mock dependencies
      service = EnglishDictionaryService(storage: mockWordStorage);
    });

    test('filterBy - success', () async {
      // Arrange
      const prefix = 'test';
      final List<Word> filteredWords = [const Word(text: 'test', value: 1)];
      when(() => mockWordStorage.query(prefix))
          .thenAnswer((_) async => filteredWords);

      // Act
      final response = await service.filterBy(prefix);

      // Assert
      expect(response.type, equals(ResponseType.success));
      expect(response.value, equals(filteredWords));
    });

    test('filterBy - error', () async {
      // Arrange
      const prefix = 'test';
      const error = 'Failed to query storage';
      when(() => mockWordStorage.query(prefix)).thenThrow(error);

      // Act
      final response = await service.filterBy(prefix);

      // Assert
      expect(response.type, equals(ResponseType.error));
      expect(response.message, equals(error));
    });

    test('saveWords - success', () async {
      // Arrange
      final List<Word> words = [
        const Word(text: 'test1', value: 1),
        const Word(text: 'test2', value: 2)
      ];

      // Act
      final response = await service.saveWords(words);

      // Assert
      expect(response.type, equals(ResponseType.success));
      verify(() => mockWordStorage.saveAll(words)).called(1);
    });

    test('saveWords - error', () async {
      // Arrange
      final List<Word> words = [
        const Word(text: 'test1', value: 1),
        const Word(text: 'test2', value: 2)
      ];
      const error = 'Failed to save words';
      when(() => mockWordStorage.saveAll(words)).thenThrow(error);

      // Act
      final response = await service.saveWords(words);

      // Assert
      expect(response.type, equals(ResponseType.error));
      expect(response.message, equals(error));
    });
  });
}
