part of 'result_bloc.dart';

/// An event sent to [ResultBloc].
sealed class ResultEvent {}


/// An event for [ResultBloc] to be filtered by.
class FilterByEvent implements ResultEvent {
  final String prefix;

  /// Creates an event with [prefix] for [ResultBloc] to be filtered by.
  const FilterByEvent(this.prefix);
}
