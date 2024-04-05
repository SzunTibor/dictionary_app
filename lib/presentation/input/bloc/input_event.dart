part of 'input_bloc.dart';

/// An event sent to the [InputBloc].
sealed class InputEvent {}

/// An event representing a submit event.
/// 
/// It contains the [text] submitted to be evaluated by a dictionary.
class SubmitWordsEvent implements InputEvent {
  final String text;

  /// Creates a new submit event with [text] to be evaluated by a dictionary.
  const SubmitWordsEvent({required this.text});
}

/// An event representing a save event.
/// 
/// It saves all accepted words to the dictionary.
class SaveListEvent implements InputEvent {
  /// Creates a new save list event.
  const SaveListEvent();
}

/// An event representing a delete event.
/// 
/// It contains the list of [words] to be deleted.
class DeleteWordsEvent implements InputEvent {
  final List<Word> words;

  /// Creates a new delete event with [words] to be deleted.
  const DeleteWordsEvent({required this.words});
}
