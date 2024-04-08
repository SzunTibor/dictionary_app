import 'package:dictionary_app_cont/data/word_evaluator/english_evaluator.dart';
import 'package:dictionary_app_cont/data/word_evaluator/simple_word_evaluator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

abstract class ResourceResolver {
  Future<String> call();
}

class MockResourceResolver extends Mock implements ResourceResolver {}

void main() {
  group('SimpleWordEvaluator', () {
    late SimpleWordEvaluator evaluator;

    setUp(() {
      // Initialize the evaluator instance
      evaluator = SimpleWordEvaluator();
    });

    test('evaluate - should return the length of the word', () async {
      // Arrange
      const word = 'test';

      // Act
      final result = await evaluator.evaluate(word);

      // Assert
      expect(result, equals(word.length));
    });
  });

  group('EnglishEvaluator', () {
    late EnglishEvaluator evaluator;
    late MockResourceResolver mockResolver;

    setUp(() {
      mockResolver = MockResourceResolver();
      evaluator = EnglishEvaluator();
    });

    test('pneumonoultramicroscopicsilicovolcanoconiosis is not a real word', () async {
      const mockWordList = 'apple banana orange';
      // Arrange
      when(() => mockResolver()).thenAnswer((_) async => mockWordList);

      // Act
      await evaluator.initialize(mockResolver.call);

      // Assert
      final result1 = await evaluator.evaluate('apple');
      expect(result1, equals(5));

      final result2 = await evaluator.evaluate('pneumonoultramicroscopicsilicovolcanoconiosis');
      expect(result2, equals(0));
    });
  });
}
