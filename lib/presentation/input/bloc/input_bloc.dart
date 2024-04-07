import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain_api.dart';
import '../../snackbar/SnackBarService.dart';

part 'input_event.dart';
part 'input_state.dart';

class InputBloc extends Bloc<InputEvent, InputState> {
  List<Word> _list = [];

  final TextProcessor _textProcessor;
  final DictionaryService _dservice;
  final SnackBarService _snackBarService;

  DictionaryInfo get dictionaryInfo => _dservice.dictionaryInfo;

  InputBloc(
    this._textProcessor,
    this._dservice,
    this._snackBarService,
  ) : super(const InitialInputState()) {
    on<InputEvent>((event, emit) => switch (event) {
          SubmitWordsEvent() => _onSubmit(event, emit),
          SaveListEvent() => _onSave(event, emit),
          DeleteWordsEvent() => _onDelete(event, emit),
        });

    emit(WordsInputState(words: _list));
  }

  Future<void> _onSubmit(
      SubmitWordsEvent event, Emitter<InputState> emit) async {
    // First we blindly add the words to the list as pending.
    // Then, once we have a response from the dictionary we
    // update accordingly.

    final String listAsString = _list.asString();

    final Iterable<String> candidates = event.text
        .toLowerCase()
        .replaceAll(RegExp(r'[,\.]'), ' ')
        .split(RegExp(r'\s+'))
        .where((c) => c.isNotEmpty)
        .where((c) => !listAsString.split(' ').contains(c))
        .toSet();

    final List<Word> pendingList = [
      ...candidates
          .map((c) => Word(text: c, value: 0, state: WordState.pending)),
    ];

    if (pendingList.isEmpty) return;

    emit(WordsInputState(words: [...pendingList, ..._list]));

    try {
      final Response<List<Word>> response =
          await _textProcessor.processText(candidates);

      switch (response.type) {
        case ResponseType.error:
          emit(ErrorInputState(words: _list, message: response.message));
          _snackBarService.showSnackBar(
              ErrorSnackBarRequest('An error occured during submit.'));
          break;
        case ResponseType.warning:
          final resolvedList = [
            ...response.value,
            ..._list,
          ];
          _list = resolvedList;
          emit(WarningInputState(words: _list, message: response.message));
          _snackBarService.showSnackBar(WarningSnackBarRequest(
              'One or more words were rejected by the dictionary:\n${response.message}'));
          break;
        case ResponseType.success:
          final resolvedList = [
            ...response.value,
            ..._list,
          ];
          _list = resolvedList;
          emit(WordsInputState(words: _list));
          break;
      }
    } catch (error) {
      emit(ErrorInputState(words: _list, message: error.toString()));
      _snackBarService.showSnackBar(
          ErrorSnackBarRequest('An error occured during submit.'));
    }
  }

  Future<void> _onSave(SaveListEvent event, Emitter<InputState> emit) async {
    if (_list.isEmpty) return;

    try {
      // Don't send words not accepted, keeping pending ones in the list.
      final List<Word> wordsPending = [];
      final List<Word> wordsToSave = [];
      for (var word in _list) {
        if (word.state == WordState.pending) {
          wordsPending.add(word);
        } else if (word.state == WordState.accepted) {
          wordsToSave.add(word);
        }
      }

      final response = await _dservice.saveWords(wordsToSave);

      switch (response.type) {
        case ResponseType.error:
          emit(ErrorInputState(words: _list, message: response.message));
          _snackBarService.showSnackBar(ErrorSnackBarRequest(
              'An error occured durng save:\n${response.message}'));
          break;
        case ResponseType.warning:
          _list
            ..clear()
            ..addAll(wordsPending);
          emit(WarningInputState(words: _list, message: response.message));
          _snackBarService.showSnackBar(WarningSnackBarRequest(
              'One or more words were rejected by the dictionary:\n${response.message}'));
          break;
        case ResponseType.success:
          _list
            ..clear()
            ..addAll(wordsPending);
          emit(WordsInputState(words: _list));
          break;
      }
    } catch (error) {
      emit(ErrorInputState(words: _list, message: error.toString()));
    }
  }

  Future<void> _onDelete(
      DeleteWordsEvent event, Emitter<InputState> emit) async {
    for (var word in event.words) {
      _list.remove(word);
    }
    emit(WordsInputState(words: _list));
  }
}
