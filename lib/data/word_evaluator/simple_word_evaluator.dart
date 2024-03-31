import 'dart:async';

import 'word_evaluator.dart';

/// A [WordEvaluator] that gives a word's length as it's value.
class SimpleWordEvaluator implements WordEvaluator {
  /// This evaluator doesn't need initialization.
  @override
  FutureOr<void> initialize() {}

  /// Returns [word]'s length as value.
  @override
  FutureOr<int> evaluate(String word) => word.length;
}
