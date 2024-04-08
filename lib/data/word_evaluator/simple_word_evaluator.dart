import 'dart:async';

import 'word_evaluator.dart';

/// A [WordEvaluator] that gives a word's length as it's value.
class SimpleWordEvaluator implements WordEvaluator<void> {
  /// This evaluator doesn't need initialization.
  @override
  FutureOr<void> initialize(void Function() resourceResolver) {
  }
  
  /// Returns [word]'s length as value.
  @override
  FutureOr<int> evaluate(String word) => word.length;
}
