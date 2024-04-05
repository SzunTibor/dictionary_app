import 'package:bloc_test/bloc_test.dart';
import 'package:dictionary_app_cont/domain/domain_api.dart';
import 'package:dictionary_app_cont/presentation/input/bloc/input_bloc.dart';
import 'package:dictionary_app_cont/presentation/snackbar/SnackBarService.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTextProcessor extends Mock implements TextProcessor {}

class MockWordStorgae extends Mock implements WordStorage {}

class MockDictionaryService extends Mock implements DictionaryService {}

class MockSnackBarService extends Mock implements SnackBarService {}

void main() {
  group('InputBloc', () {
    late InputBloc inputBloc;
    late MockTextProcessor mockTextProcessor;
    late MockDictionaryService mockDictionaryService;
    late MockSnackBarService mockSnackBarService;

    setUp(() {
      mockTextProcessor = MockTextProcessor();
      mockDictionaryService = MockDictionaryService();
      mockSnackBarService = MockSnackBarService();
      inputBloc = InputBloc(
          mockTextProcessor, mockDictionaryService, mockSnackBarService);
    });

    blocTest<InputBloc, InputState>(
      'emits WordsInputState on SubmitWordsEvent',
      build: () {
        final words = [
          const Word(text: 'wordone', value: 1, state: WordState.accepted),
          const Word(text: 'wordtwo', value: 2, state: WordState.accepted),
        ];
        when(() => mockTextProcessor.processText(any()))
            .thenAnswer((_) => Response.success(words));
        return inputBloc;
      },
      act: (bloc) => bloc.add(const SubmitWordsEvent(text: 'wordone wordtwo')),
      expect: () {
        return [
          isA<WordsInputState>(), // Pending
          isA<WordsInputState>(), // Resolved
        ];
      },
      verify: (bloc) {
        verify(() => mockTextProcessor.processText(any())).called(1);
      },
    );

    blocTest<InputBloc, InputState>(
      'emits ErrorInputState on SubmitWordsEvent when TextProcessor throws error',
      build: () {
        const errorMessage = 'Input error';
        when(() => mockTextProcessor.processText(any()))
            .thenThrow(errorMessage);
        return inputBloc;
      },
      act: (bloc) => bloc.add(const SubmitWordsEvent(text: 'wordone wordtwo')),
      expect: () {
        return [
          isA<WordsInputState>(), // Pending
          isA<ErrorInputState>(), // Resolved
        ];
      },
      verify: (bloc) {
        verify(() => mockTextProcessor.processText(any())).called(1);
      },
    );

    blocTest<InputBloc, InputState>(
      'emits WarningInputState on SubmitWordsEvent',
      build: () {
        final words = [
          const Word(text: 'word1', value: 1, state: WordState.rejected),
          const Word(text: 'wordtwo', value: 2, state: WordState.accepted),
        ];
        when(() => mockTextProcessor.processText(any()))
            .thenAnswer((_) => Response.warning(words.first.text, [words[1]]));
        return inputBloc;
      },
      act: (bloc) => bloc.add(const SubmitWordsEvent(text: 'wordone wordtwo')),
      expect: () {
        return [
          isA<WordsInputState>(), // Pending
          isA<WarningInputState>(), // Warning message
          isA<WordsInputState>(), // Accepted words
        ];
      },
      verify: (bloc) {
        verify(() => mockTextProcessor.processText(any())).called(1);
      },
    );

    blocTest<InputBloc, InputState>(
      'emits WordsInputState on SaveListEvent',
      build: () {
        final words = [
          const Word(text: 'wordone', value: 1, state: WordState.accepted),
          const Word(text: 'wordtwo', value: 2, state: WordState.accepted)
        ];
        when(() => mockDictionaryService.saveWords(any()))
            .thenAnswer((_) => Response.success(words));
        return inputBloc;
      },
      act: (bloc) => bloc.add(const SaveListEvent()),
      expect: () {
        return [
          isA<WordsInputState>(),
        ];
      },
      verify: (bloc) {
        verify(() => mockDictionaryService.saveWords(any())).called(1);
      },
    );

    blocTest<InputBloc, InputState>(
      'emits WarningInputState with warning message and WordsInputState on SaveListEvent',
      build: () {
        final words = [
          const Word(text: 'word1', value: 1, state: WordState.rejected),
          const Word(text: 'wordtwo', value: 2, state: WordState.accepted)
        ];
        when(() => mockDictionaryService.saveWords(any()))
            .thenAnswer((_) => Response.warning(words.first.text, [words[1]]));
        return inputBloc;
      },
      act: (bloc) => bloc.add(const SaveListEvent()),
      expect: () {
        return [
          isA<WarningInputState>(),
          isA<WordsInputState>(),
        ];
      },
      verify: (bloc) {
        verify(() => mockDictionaryService.saveWords(any())).called(1);
      },
    );

    blocTest<InputBloc, InputState>(
      'emits ErrorInputState on SaveListEvent error.',
      build: () {
        when(() => mockDictionaryService.saveWords(any()))
            .thenThrow('Error message');
        return inputBloc;
      },
      act: (bloc) => bloc.add(const SaveListEvent()),
      expect: () {
        return [
          isA<ErrorInputState>(),
        ];
      },
      verify: (bloc) {
        verify(() => mockDictionaryService.saveWords(any())).called(1);
      },
    );
  });
}
