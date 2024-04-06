enum WordState {
  pending,
  rejected,
  duplicate,
  accepted,
}

/// A class representing a word along with its associated value.
class Word {
  /// The text representation of the word.
  final String text;

  /// The value associated with the word.
  final int value;

  final WordState state;

  /// Constructs a [Word] instance with the given [text] and [value].
  const Word({required this.text, required this.value, required this.state});

  bool get isPending => state == WordState.pending;
  bool get isRejected => state == WordState.rejected;
  bool get isAccepted => state == WordState.accepted;
  bool get isDuplicate => state == WordState.duplicate;
}
