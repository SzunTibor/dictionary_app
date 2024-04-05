part of 'result_bloc.dart';

/// A state emitted by the [ResultBloc].
sealed class ResultState {}

/// The initial state for [ResultBloc].
class InitialResultState implements ResultState {
  /// Creates a new representation of the initial [ResultBloc] state.
  const InitialResultState();
}

/// A [ResultBloc] state containing a [list] of [Word]s.
class WordsResultState implements ResultState {
  final List<Word> list;

  /// Creates a new [WordsResultState] state with a [list] of [Word]s.
  const WordsResultState({required this.list});
}

/// A [ResultBloc] state representing an error state.
class ErrorResultState implements ResultState {
  /// The mesage desxribing the weeoe.
  final String message;

  /// Creates new [ErrorResultState] with a [message] describing the error.
  const ErrorResultState({required this.message});
}
