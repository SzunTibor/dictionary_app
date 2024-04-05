part of 'input_bloc.dart';

/// A state emitted by the [InputBloc].
sealed class InputState {}

/// The initial state of the [InputBloc].
class InitialInputState implements InputState {
  /// Creates a new representation of the initial [InputBloc] state.
  const InitialInputState();
}

/// A state of the [InputBloc] containing a list of locally stored [words].
class WordsInputState implements InputState {
  /// The list of [Word]s emitted by the [InputBloc].
  final List<Word> words;

  /// Creates a new state of [InputBloc] representing it's state as [words].
  const WordsInputState({required this.words});
}

/// A state of the [InputBloc] containing a warning [message].
class WarningInputState implements InputState {
  /// The message describing the warning.
  final String message;

  /// Creates a new state of [InputBloc] with a warning [message.
  const WarningInputState({required this.message});
}

/// A state of the [InputBloc] containing an error [message].
class ErrorInputState implements InputState {
  /// The message describing the error.
  final String message;

  /// Creates a new state of [InputBloc] with an error [message.
  const ErrorInputState(this.message);
}
