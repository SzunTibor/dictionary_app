/// An abstract class representing information about a dictionary.
abstract class DictionaryInfo {
  /// The total value of the words in the dictionary.
  final int value;

  /// The alphabet used in the words of the dictionary.
  /// Characters are ordered in an alphabetical order.
  final List<String> alphabet;

  /// The symbol representing any character in the words of the dictionary.
  final String joker;

  /// Constructs a [DictionaryInfo] instance with the given parameters.
  DictionaryInfo({
    required this.value,
    required this.alphabet,
    required this.joker,
  })  : assert(joker.length == 1, 'The joker must be a single character'),
        assert(alphabet.isNotEmpty, 'The alphabet must not be empty.'),
        assert(() {
          for (var letter in alphabet) {
            if (letter.isEmpty) return false;
          }
          return true;
        }(), 'The alphabet must not contain empty letters.');
}
