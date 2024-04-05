part of 'result_bloc.dart';

/// A state emitted by the [ResultBloc].
sealed class ResultState {}

/// The initial state for [ResultBloc].
class InitialResultState implements ResultState {
  /// Creates a new representation of the initial [ResultBloc] state.
  const InitialResultState();
}

/// A [ResultBloc] state containing a [list] of [WordPresentation]s.
class WordsListState implements ResultState {
  final List<Word> list;

  /// Creates a new [WordsListState] event with a [list] of [WordPresentation]s.
  const WordsListState({required this.list});
}
