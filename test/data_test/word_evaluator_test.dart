import 'package:dictionary_app_cont/data/word_evaluator/simple_word_evaluator.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
