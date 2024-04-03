// Mock classes
import 'package:dictionary_app_cont/domain/domain_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements WordStorage {}

class MockDictionary extends Mock implements Dictionary {}

class MockWordEvaluator extends Mock implements WordEvaluator {}

void main() {
  group('DefaultTextProcessor', () {
    late MockStorage mockWordStorage;
    late Dictionary mockDictionary;
    late DefaultTextProcessor textProcessor;
    late MockWordEvaluator mockEvaluator;

    setUp(() {
      mockWordStorage = MockStorage();
      mockDictionary = MockDictionary();
      mockEvaluator = MockWordEvaluator();
      textProcessor = DefaultTextProcessor(
          dictionary: mockDictionary, evaluator: mockEvaluator);
      when(() => mockEvaluator.evaluate(any())).thenAnswer((_) => 0);
      when(() => mockDictionary.storage).thenReturn(mockWordStorage);
      when(() => mockDictionary.value).thenReturn(0);
      when(() => mockDictionary.maxWordLength).thenReturn(10);
      when(() => mockDictionary.alphabet)
          .thenReturn('abcdefghijklmnopqrstuvwxyz'.split(''));
    });

    test('processText - existing word', () async {
      // Arrange
      when(() => mockDictionary.lookupText('existing'))
          .thenAnswer((_) async => const Word(text: 'existing', value: 0));
      when(() => mockDictionary.hasInvalidChar(any())).thenReturn(false);
      when(() => mockDictionary.isTextTooLong(any())).thenReturn(false);

      // Act
      final response = await textProcessor.processText(['existing']);

      // Assert
      expect(response.type, equals(ResponseType.warning));
      expect(response.value.length, equals(0));
      expect(response.message, equals('existing'));
    });

    test('processText - new word', () async {
      // Arrange
      when(() => mockDictionary.lookupText('new'))
          .thenAnswer((_) async => null);
      when(() => mockEvaluator.evaluate('new')).thenAnswer((_) async => 10);
      when(() => mockDictionary.hasInvalidChar(any())).thenReturn(false);
      when(() => mockDictionary.isTextTooLong(any())).thenReturn(false);

      // Act
      final response = await textProcessor.processText(['new']);

      // Assert
      expect(response.type, equals(ResponseType.success));
      expect(response.value.length, equals(1));
      expect(response.value[0].text, equals('new'));
      expect(response.value[0].value, equals(10));
    });

    test('processText - too long word', () async {
      // Arrange
      when(() => mockDictionary.lookupText(any()))
          .thenAnswer((_) async => null);
      when(() => mockDictionary.isTextTooLong('toolong')).thenReturn(true);
      when(() => mockDictionary.hasInvalidChar(any())).thenReturn(false);

      // Act
      final response = await textProcessor.processText(['toolong']);

      // Assert
      expect(response.type, equals(ResponseType.warning));
      expect(response.value.length, equals(0));
      expect(response.message, equals('toolong'));
    });

    test('processText - invalid char word', () async {
      // Arrange
      when(() => mockDictionary.lookupText(any()))
          .thenAnswer((_) async => null);
      when(() => mockDictionary.isTextTooLong(any())).thenReturn(false);
      when(() => mockDictionary.hasInvalidChar('invalid@char'))
          .thenReturn(true);

      // Act
      final response = await textProcessor.processText(['invalid@char']);

      // Assert
      expect(response.type, equals(ResponseType.warning));
      expect(response.value.length, equals(0));
      expect(response.message, equals('invalid@char'));
    });

    test('processText - error in lookup', () async {
      // Arrange
      const errorMessage = 'Evaluation error';
      when(() => mockDictionary.lookupText('error')).thenThrow(errorMessage);
      when(() => mockDictionary.isTextTooLong(any())).thenReturn(false);
      when(() => mockDictionary.hasInvalidChar(any())).thenReturn(false);

      // Act
      final response = await textProcessor.processText(['error']);

      // Assert
      verify(() => mockDictionary.lookupText('error')).called(1);
      expect(response.type, equals(ResponseType.error));
      expect(response.message, equals(errorMessage));
      expect(response.value.isEmpty, isTrue);
    });

    test('processText - error in evaluation', () async {
      // Arrange
      when(() => mockDictionary.lookupText('new'))
          .thenAnswer((_) async => null);
      when(() => mockDictionary.isTextTooLong(any())).thenReturn(false);
      when(() => mockDictionary.hasInvalidChar(any())).thenReturn(false);
      const errorMessage = 'Evaluation error';
      when(() => mockEvaluator.evaluate('new')).thenThrow(errorMessage);

      // Act
      final response = await textProcessor.processText(['new']);

      // Assert
      expect(response.type, equals(ResponseType.error));
      expect(response.message, equals(errorMessage));
      expect(response.value.isEmpty, isTrue);
    });
  });
}
