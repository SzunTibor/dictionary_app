import 'dart:async';

import '../domain_api.dart';

/// For each item in [text], returns an evaluated [Word].
///
/// First the item is checked if it is already stored
/// in a [Dictionary]. If it is, it gets the value of 0.
/// If it is not stored it gets evaluated by a [WordEvaluator].
class DefaultTextProcessor implements TextProcessor {
  final Dictionary _dictionary;
  final WordEvaluator _evaluator;

  DefaultTextProcessor(
      {required Dictionary dictionary, required WordEvaluator evaluator})
      : _evaluator = evaluator,
        _dictionary = dictionary;

  /// Processes the provided list of text items.
  ///
  /// For each text item, checks if it is already stored in the [Dictionary].
  /// If not stored, evaluates each text item using a [WordEvaluator].
  /// Returns a [Response] containing a list of accepted and evaluated [Word]s.
  /// Duplicates are included in the list with 0 value and marked as duplicate.
  /// If any text is rejected it is returned in [Response.message]
  /// separated by a space with [Response.type] set to warning.
  @override
  FutureOr<Response<List<Word>>> processText(Iterable<String> text) async {
    final List<Word> wordsAccepted = [];
    final List<String> wordsRejected = [];

    for (String candidate in text) {
      int value = 0;
      WordState state = WordState.pending;

      // Check for rejected.
      if (_dictionary.isTextTooLong(candidate) ||
          _dictionary.hasInvalidChar(candidate)) {
        value = 0;
        state = WordState.rejected;
      }

      // Check for duplicates.
      if (state == WordState.pending) {
        try {
          final Word? found = await _dictionary.lookupText(candidate);
          if (found != null) {
            value = 0;
            state = WordState.duplicate;
          }
        } catch (error) {
          return Response.error(error.toString(), []);
        }
      }

      // Evaluate word.
      if (state == WordState.pending) {
        try {
          value = await _evaluator.evaluate(candidate);
          if (value > 0) {
            state = WordState.accepted;
          } else {
            state = WordState.rejected;
          }
        } catch (error) {
          return Response.error(error.toString(), []);
        }
      }

      switch (state) {
        case WordState.accepted:
        case WordState.duplicate:
          wordsAccepted.add(Word(text: candidate, value: value, state: state));
          break;
        case WordState.rejected:
          wordsRejected.add(candidate);
          break;
        case WordState.pending:
          assert(false, 'Unresolved word candidate: $candidate');
      }
    }

    if (wordsRejected.isNotEmpty) {
      return Response.warning(wordsRejected.join(' '), wordsAccepted);
    } else {
      return Response.success(wordsAccepted);
    }
  }
}
