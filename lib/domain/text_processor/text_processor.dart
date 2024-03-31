import 'dart:async';

import '../../data/word_evaluator/word_evaluator.dart';
import '../models/dictionary.dart';
import '../models/word.dart';
import '../response.dart';

/// For each item in [text], returns an evaluated [Word].
///
/// First the item is checked if it is already stored
/// in a [Dictionary]. If it is, it gets the value of 0.
/// If it is not stored it gets evaluated by a [WordEvaluator].
abstract interface class TextProcessor {
  // final Dictionary _dictionary;
  // final WordEvaluator _evaluator;

  FutureOr<Response<List<Word>>> processText(List<String> text);
}
