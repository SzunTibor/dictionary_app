import 'package:bloc_test/bloc_test.dart';
import 'package:dictionary_app_cont/domain/domain_api.dart';
import 'package:dictionary_app_cont/presentation/result/bloc/result_bloc.dart';
import 'package:dictionary_app_cont/presentation/snackbar/SnackBarService.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDictionary extends Mock implements Dictionary {}

class MockDictionaryService extends Mock implements DictionaryService {}

class MockSnackBarService extends Mock implements SnackBarService {}

void main() {
  group('ResultBloc', () {
    late ResultBloc resultBloc;
    late MockDictionary mockDictionary = MockDictionary();
    late DictionaryService mockDictionaryService = MockDictionaryService();
    late SnackBarService mockSnackBarService = MockSnackBarService();

    setUp(() {
      when(() => mockDictionary.value).thenReturn(0);
      when(() => mockDictionary.maxWordLength).thenReturn(10);
      when(() => mockDictionary.joker).thenReturn('*');
      when(() => mockDictionary.alphabet)
          .thenReturn('abcdefghijklmnopqrstuvwxyz'.split(''));
      when(() => mockDictionaryService.dictionaryInfo)
          .thenReturn(mockDictionary);
      resultBloc = ResultBloc(mockDictionaryService, mockSnackBarService);
    });

    blocTest<ResultBloc, ResultState>(
      'emits WordsResultState on FilterByEvent.',
      build: () {
        when(() => mockDictionaryService.filterBy(any())).thenAnswer((_) =>
            Response.success([
              const Word(text: 'test', value: 0, state: WordState.accepted)
            ]));
        return resultBloc;
      },
      act: (bloc) => bloc.add(const FilterByEvent('test')),
      expect: () {
        return [
          isA<WordsResultState>(),
        ];
      },
      verify: (bloc) {
        expect((bloc.state as WordsResultState).list[0].text, equals('test'));
        expect((bloc.state as WordsResultState).list[0].state,
            equals(WordState.accepted));
        verify(() => mockDictionaryService.filterBy('test')).called(1);
      },
    );

    blocTest<ResultBloc, ResultState>(
      'emits ErrorResultState on FilterByEvent when DictionaryService returns error.',
      build: () {
        when(() => mockDictionaryService.filterBy(any()))
            .thenThrow('Error message');
        return resultBloc;
      },
      act: (bloc) => bloc.add(const FilterByEvent('test')),
      expect: () {
        return [
          isA<ErrorResultState>(),
          isA<WordsResultState>(),
        ];
      },
      verify: (bloc) {
        verify(() => mockDictionaryService.filterBy('test')).called(1);
      },
    );
  });
}
