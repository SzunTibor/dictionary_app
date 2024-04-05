part of 'result_bloc.dart';

/// An event sent to a [ResultBloc].
sealed class ResultEvent {}

/// An event for [ResultBloc] to be filtered by.
class FilterByEvent implements ResultEvent {
  /// The prefix string used to filter by.
  final String prefix;

  /// Creates an event with [prefix] for [ResultBloc] to be filtered by.
  const FilterByEvent(this.prefix);
}
