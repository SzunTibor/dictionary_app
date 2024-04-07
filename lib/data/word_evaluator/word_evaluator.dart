import 'dart:async';

/// An evaluator to determine the value of a word.
abstract interface class WordEvaluator<T> {
  /// Initializes the word evaluator.
  /// This method should be called before any evaluation operations.
  FutureOr<void> initialize();

  /// Evaluates the given [word] and returns its value.
  FutureOr<int> evaluate(String word);
}
