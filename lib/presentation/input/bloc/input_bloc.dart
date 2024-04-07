import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain_api.dart';
import '../../snackbar/SnackBarService.dart';

part 'input_event.dart';
part 'input_state.dart';

class InputBloc extends Bloc<InputEvent, InputState> {
  List<Word> _list = [];
  List<Word> _pendingList = [];

  final TextProcessor _textProcessor;
  final DictionaryService _dservice;
  final SnackBarService _snackBarService;

  DictionaryInfo get dictionaryInfo => _dservice.dictionaryInfo;

  InputBloc(
    this._textProcessor,
    this._dservice,
    this._snackBarService,
  ) : super(const WordsInputState(words: [])) {
    on<InputEvent>((event, emit) => switch (event) {
          SubmitWordsEvent() => _onSubmit(event, emit),
          ResolvePendingEvent() => _onResolve(event, emit),
          SaveListEvent() => _onSave(event, emit),
          DeleteWordsEvent() => _onDelete(event, emit),
        });
  }

  void _onSubmit(SubmitWordsEvent event, Emitter<InputState> emit) {
    // First we blindly add the words to the list as pending.
    // Then, once we have a response from the dictionary we
    // update accordingly.

    final Iterable<String> candidates = event.text
        .toLowerCase()
        .replaceAll(RegExp(r'[,\.]'), ' ')
        .split(RegExp(r'\s+'))
        .where((c) => c.isNotEmpty)
        .where((c) => !_list.asString().split(' ').contains(c))
        .where((c) => !_pendingList.asString().split(' ').contains(c))
        .toSet();

    final List<Word> pendingList = [
      ...candidates
          .map((c) => Word(text: c, value: 0, state: WordState.pending)),
    ];

    if (pendingList.isEmpty) return;

    _pendingList = [...pendingList, ..._pendingList];

    emit(WordsInputState(words: [..._pendingList, ..._list]));

    add(const ResolvePendingEvent());
  }

  Future<void> _onResolve(
      ResolvePendingEvent event, Emitter<InputState> emit) async {
    if (_pendingList.isEmpty) return;

    final candidates = _pendingList.map((e) => e.text).toSet();

    try {
      final Response<List<Word>> response =
          await _textProcessor.processText(candidates);

      switch (response.type) {
        case ResponseType.error:
          emit(ErrorInputState(
              words: [..._pendingList, ..._list], message: response.message));
          _snackBarService.showSnackBar(
              ErrorSnackBarRequest('An error occured during submit.'));
          break;
        case ResponseType.warning:
          _list = [
            ...response.value,
            ..._list,
          ];
          _pendingList.clear();
          emit(WarningInputState(words: _list, message: response.message));
          _snackBarService.showSnackBar(WarningSnackBarRequest(
              'One or more words were rejected by the dictionary:\n${response.message}'));
          break;
        case ResponseType.success:
          _list = [
            ...response.value,
            ..._list,
          ];
          _pendingList.clear();
          emit(WordsInputState(words: _list));
          break;
      }
    } catch (error) {
      emit(ErrorInputState(
          words: [..._pendingList, ..._list], message: error.toString()));
      _snackBarService.showSnackBar(
          ErrorSnackBarRequest('An error occured during submit.'));
    }
  }

  Future<void> _onSave(SaveListEvent event, Emitter<InputState> emit) async {
    if (_list.isEmpty) return;

    try {
      final List<Word> wordsToSave = _list
          .where((element) => element.state == WordState.accepted)
          .toList();

      final response = await _dservice.saveWords(wordsToSave);

      switch (response.type) {
        case ResponseType.error:
          emit(ErrorInputState(
              words: [..._pendingList, ..._list], message: response.message));
          _snackBarService.showSnackBar(ErrorSnackBarRequest(
              'An error occured durng save:\n${response.message}'));
          break;
        case ResponseType.warning:
          _list.clear();
          emit(WarningInputState(
              words: [..._pendingList, ..._list], message: response.message));
          _snackBarService.showSnackBar(WarningSnackBarRequest(
              'One or more words were rejected by the dictionary:\n${response.message}'));
          break;
        case ResponseType.success:
          _list.clear();
          emit(WordsInputState(words: [..._pendingList, ..._list]));
          break;
      }
    } catch (error) {
      emit(ErrorInputState(
          words: [..._pendingList, ..._list], message: error.toString()));
    }
  }

  void _onDelete(DeleteWordsEvent event, Emitter<InputState> emit) {
    for (var word in event.words) {
      _list.remove(word);
      _pendingList.remove(word);
    }
    emit(WordsInputState(words: [..._pendingList, ..._list]));
  }
}
