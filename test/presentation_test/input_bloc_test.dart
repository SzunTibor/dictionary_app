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

        // Need to fill the inner list for _onSave not to short-circuit.
        when(() => mockTextProcessor.processText(any()))
            .thenAnswer((_) => Response.success(words));
        inputBloc.add(const SubmitWordsEvent(text: 'wordone wordtwo'));

        return inputBloc;
      },
      act: (bloc) async {
        // need to drive the event loop otherwise _onSave finds and empty list.
        await Future.delayed(Duration.zero);
        bloc.add(const SaveListEvent());
      },
      expect: () {
        return [
          isA<WordsInputState>(), // Pending
          isA<WordsInputState>(), // Resolved
          isA<WordsInputState>(), // List cleared
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

        // Need to fill the inner list for _onSave not to short-circuit.
        when(() => mockTextProcessor.processText(any()))
            .thenAnswer((_) => Response.success(words));
        inputBloc.add(const SubmitWordsEvent(text: 'wordone wordtwo'));

        return inputBloc;
      },
      act: (bloc) async {
        // need to drive the event loop otherwise _onSave finds and empty list.
        await Future.delayed(Duration.zero);
        bloc.add(const SaveListEvent());
      },
      expect: () {
        return [
          isA<WordsInputState>(), // Pending
          isA<WordsInputState>(), // Resolved
          isA<WarningInputState>(),
        ];
      },
      verify: (bloc) {
        verify(() => mockDictionaryService.saveWords(any())).called(1);
      },
    );

    blocTest<InputBloc, InputState>(
      'emits ErrorInputState on SaveListEvent error.',
      build: () {
        final words = [
          const Word(text: 'word1', value: 1, state: WordState.rejected),
          const Word(text: 'wordtwo', value: 2, state: WordState.accepted)
        ];

        when(() => mockDictionaryService.saveWords(any()))
            .thenThrow('Error message');

        // Need to fill the inner list for _onSave not to short-circuit.
        when(() => mockTextProcessor.processText(any()))
            .thenAnswer((_) => Response.success(words));
        inputBloc.add(const SubmitWordsEvent(text: 'wordone wordtwo'));

        return inputBloc;
      },
      act: (bloc) async {
        // need to drive the event loop otherwise _onSave finds and empty list.
        await Future.delayed(Duration.zero);
        bloc.add(const SaveListEvent());
      },
      expect: () {
        return [
          isA<WordsInputState>(), // Pending
          isA<WordsInputState>(), // Resolved
          isA<ErrorInputState>(),
        ];
      },
      verify: (bloc) {
        verify(() => mockDictionaryService.saveWords(any())).called(1);
      },
    );

    blocTest(
      'clears pending properly on consecutive submits',
      build: () {
        final words = [
          const Word(text: 'wordone', value: 1, state: WordState.accepted),
          const Word(text: 'wordtwo', value: 2, state: WordState.accepted)
        ];

        when(() => mockTextProcessor.processText([words[0].text]))
            .thenAnswer((_) => Response.success([words[0]]));
        when(() => mockTextProcessor.processText([words[1].text]))
            .thenAnswer((_) => Response.success([words[1]]));
        when(() =>
                mockTextProcessor.processText(words.map((e) => e.text).toSet()))
            .thenAnswer((_) => Response.success(words));

        return inputBloc;
      },
      act: (bloc) async {
        inputBloc.add(const SubmitWordsEvent(text: 'wordone'));
        inputBloc.add(const SubmitWordsEvent(text: 'wordtwo'));
        await Future.delayed(Duration.zero);
      },
      expect: () {
        return [
          isA<WordsInputState>(),
          isA<WordsInputState>(),
          isA<WordsInputState>(),
          // equals(
          //   const WordsInputState(
          //     words: [
          //       Word(text: 'wordone', value: 0, state: WordState.pending),
          //     ],
          //   ),
          // ),
          // equals(
          //   const WordsInputState(
          //     words: [
          //       Word(text: 'wordtwo', value: 0, state: WordState.pending),
          //       Word(text: 'wordone', value: 0, state: WordState.pending),
          //     ],
          //   ),
          // ),
          // equals(
          //   const WordsInputState(
          //     words: [
          //       Word(text: 'wordone', value: 1, state: WordState.accepted),
          //       Word(text: 'wordtwo', value: 2, state: WordState.accepted),
          //     ],
          //   ),
          // ),
        ];
      },
      verify: (bloc) {
        verifyNever(() => mockTextProcessor.processText({'wordone'}));
        verifyNever(() => mockTextProcessor.processText({'wordtwo'}));
        verify(() => mockTextProcessor.processText({'wordone', 'wordtwo'}))
            .called(1);
      },
    );
  });
}
