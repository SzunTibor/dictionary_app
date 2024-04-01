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
  /// If not stored, evaluates the text item using a [WordEvaluator].
  /// Returns a [Response] containing a list of evaluated [Word]s.
  @override
  FutureOr<Response<List<Word>>> processText(List<String> text) async {
    final List<Word> result = [];

    for (var candidate in text) {
      int value = 1;

      // Check for duplicates.
      try {
        final Word? found = await _dictionary.lookupText(candidate);
        if (found != null) value = 0;
      } catch (error) {
        return Response.error(error.toString(), []);
      }

      if (_dictionary.isTextTooLong(candidate)) {
        value = 0;
      }

      if (_dictionary.hasInvalidChar(candidate)) {
        value = 0;
      }

      if (value != 0) {
        try {
          value = await _evaluator.evaluate(candidate);
        } catch (error) {
          return Response.error(error.toString(), []);
        }
      }

      result.add(Word(text: candidate, value: value));
    }

    return Response.success(result);
  }
}
