part of 'input_bloc.dart';

/// A state emitted by the [InputBloc].
sealed class InputState {}

/// The initial state of the [InputBloc].
class InitialInputState implements InputState {
  const InitialInputState();
}

/// A state of the [InputBloc] containing a list of locally stored [words].
class WordsInputState implements InputState {
  final List<WordPresentation> words;

  const WordsInputState({required this.words});
}

/// A state of the [InputBloc] containing a warning [message].
class WarningInputState implements InputState {
  final String message;

  const WarningInputState({required this.message});
}

/// A state of the [InputBloc] containing an error [message].
class ErrorInputState implements InputState {
  final String message;

  const ErrorInputState(this.message);
}
