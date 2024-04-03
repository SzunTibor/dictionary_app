import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain_api.dart';
import '../../snackbar/SnackBarService.dart';
import '../../word/word_presentation.dart';

part 'input_event.dart';
part 'input_state.dart';

class InputBloc extends Bloc<InputEvent, InputState> {
  List<WordPresentation> _list = [];

  final TextProcessor _textProcessor;
  final DictionaryService _dservice;
  final SnackBarService _snackBarService;

  InputBloc(this._textProcessor, this._dservice, this._snackBarService)
      : super(const InitialInputState()) {
    on<InputEvent>((event, emit) => switch (event) {
          SubmitWordsEvent() => _onSubmit(event, emit),
          SaveListEvent() => _onSave(event, emit),
          DeleteWordsEvent() => _onDelete(event, emit),
        });
  }

  Future<void> _onSubmit(
      SubmitWordsEvent event, Emitter<InputState> emit) async {
    // First we blindly add the words to the list as pending.
    // Then, once we have a response from the dictionary we
    // update accordingly.

    final Iterable<String> candidates =
        event.text.replaceAll(',', '').split(RegExp(r'\s+'));

    if (candidates.isEmpty) return;

    final pendingList = [
      ...candidates.map((c) => WordPresentation(
          text: c, value: 0, state: WordPresentationState.pending)),
      ..._list,
    ];

    emit(WordsInputState(words: pendingList));

    try {
      final Response<List<Word>> response =
          await _textProcessor.processText(candidates.toList());

      switch (response.type) {
        case ResponseType.error:
          emit(ErrorInputState(response.message));
          _snackBarService.showSnackBar(ErrorSnackBarRequest(
              'An error occured during submit:\n${response.message}'));
          break;
        case ResponseType.warning:
          final resolvedList = [
            ..._evaluatedWordsToAccpeted(response.value),
            ..._list,
          ];
          _list = resolvedList;
          emit(WarningInputState(message: response.message));
          emit(WordsInputState(words: _list));
          _snackBarService.showSnackBar(WarningSnackBarRequest(
              'One or more words were rejected by the dictionary:\n${response.message}'));
          break;
        case ResponseType.success:
          final resolvedList = [
            ..._evaluatedWordsToAccpeted(response.value),
            ..._list,
          ];
          _list = resolvedList;
          emit(WordsInputState(words: _list));
          break;
      }
    } catch (error) {
      emit(ErrorInputState(error.toString()));
    }
  }

  Future<void> _onSave(SaveListEvent event, Emitter<InputState> emit) async {
    try {
      final response = await _dservice.saveWords(_list);

      switch (response.type) {
        case ResponseType.error:
          emit(ErrorInputState(response.message));
          _snackBarService.showSnackBar(ErrorSnackBarRequest(
              'An error occured durng save:\n${response.message}'));
          break;
        case ResponseType.warning:
          emit(WarningInputState(message: response.message));
          _list.clear();
          emit(WordsInputState(words: _list));
          _snackBarService.showSnackBar(WarningSnackBarRequest(
              'One or more words were rejected by the dictionary:\n${response.message}'));
          break;
        case ResponseType.success:
          _list.clear();
          emit(WordsInputState(words: _list));
          break;
      }
    } catch (error) {
      emit(ErrorInputState(error.toString()));
    }
  }

  Future<void> _onDelete(
      DeleteWordsEvent event, Emitter<InputState> emit) async {
    for (var word in event.words) {
      _list.remove(word);
    }
    emit(WordsInputState(words: _list));
  }

  Iterable<WordPresentation> _evaluatedWordsToAccpeted(List<Word> words) {
    return words.map((w) => WordPresentation(
        text: w.text, value: w.value, state: WordPresentationState.accepted));
  }
}
