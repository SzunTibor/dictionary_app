part of 'input_bloc.dart';

/// A state emitted by the [InputBloc].
sealed class InputState {}

/// A state of the [InputBloc] containing a list of locally stored [words].
class WordsInputState implements InputState {
  /// The list of [Word]s emitted by the [InputBloc].
  final List<Word> words;

  /// Creates a new state of [InputBloc] representing it's state as [words].
  const WordsInputState({required this.words});
}

/// A state of the [InputBloc] containing a warning [message].
class WarningInputState extends WordsInputState {
  /// The message describing the warning.
  final String message;

  /// Creates a new state of [InputBloc] with a warning [message.
  const WarningInputState({required super.words, required this.message});
}

/// A state of the [InputBloc] containing an error [message].
class ErrorInputState extends WordsInputState {
  /// The message describing the error.
  final String message;

  /// Creates a new state of [InputBloc] with an error [message.
  const ErrorInputState({required super.words, required this.message});
}
