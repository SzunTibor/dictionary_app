/// An abstract class representing information about a dictionary.
abstract class DictionaryInfo {
  /// The total value of the words in the dictionary.
  final int value;

  /// The alphabet used in the words of the dictionary.
  /// Characters are ordered in an alphabetical order.
  final List<String> alphabet;

  /// The symbol representing any character in the words of the dictionary.
  final String joker;

  /// The maximum length of a word to be stored.
  final int maxWordLength;

  /// Constructs a [DictionaryInfo] instance with the given parameters.
  DictionaryInfo({
    required this.value,
    required this.alphabet,
    required this.joker,
    required this.maxWordLength,
  })  : assert(joker.length == 1, 'The joker must be a single character'),
        assert(alphabet.isNotEmpty, 'The alphabet must not be empty.'),
        assert(() {
          for (var letter in alphabet) {
            if (letter.length != 1) return false;
          }
          return true;
        }(), 'An alphabet letter must be a single character.');
}

/// Helper methods for handling Dictionary alphabets.
extension DictionaryAlphabetHelper on List<String> {
  Iterable<int> asRunes() {
    return map((letter) => letter.runes.first);
  }
}
