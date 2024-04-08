import 'dart:async';

/// An evaluator to determine the value of a word.
///
/// An implementation might ask for a specific resource to be initialized with.
/// In that case a resolver function should be provided to [initialize].
abstract interface class WordEvaluator<T> {

  /// Initializes the word evaluator with resources given by [resourceResolver].
  /// This method should be called before any evaluation operations.
  FutureOr<void> initialize(T Function() resourceResolver);

  /// Evaluates the given [word] and returns its value.
  FutureOr<int> evaluate(String word);
}
