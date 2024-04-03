import 'package:dictionary_app_cont/data/word_storage/map_storage.dart';
import 'package:dictionary_app_cont/data/word_storage/word_storage.dart';
import 'package:dictionary_app_cont/domain/models/word.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MapWordStorage', () {
    late WordStorage wordStorage;

    setUp(() {
      wordStorage = MapWordStorage();
    });

    test('lookup - should return null if word not found', () async {
      // Arrange
      const nonExistentWord = 'nonexistent';

      // Act
      final result = await wordStorage.lookup(nonExistentWord);

      // Assert
      expect(result, isNull);
    });

    test('query - should return an empty list if no words match the prefix',
        () async {
      // Arrange
      const prefix = 'nonexistent';

      // Act
      final result = await wordStorage.query(prefix);

      // Assert
      expect(result, isEmpty);
    });

    test('save - should save the word to storage', () async {
      // Arrange
      const word = Word(text: 'test', value: 1);

      // Act
      await wordStorage.save(word);

      // Assert
      final result = await wordStorage.lookup(word.text);
      expect(result?.text, word.text);
    });

    test('saveAll - should save all words to storage', () async {
      // Arrange
      final words = [
        const Word(text: 'test1', value: 1),
        const Word(text: 'test2', value: 2),
      ];

      // Act
      await wordStorage.saveAll(words);

      // Assert
      final result = await wordStorage.query('test');
      expect(result.length, 2);
    });
  });
}
