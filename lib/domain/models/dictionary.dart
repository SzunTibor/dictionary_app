import '../../data/word_storage/word_storage.dart';
import 'dictionary_info.dart';
import 'word.dart';

/// A class representing a dictionary with
/// associated storage for word operations.
class Dictionary extends DictionaryInfo {
  /// The storage used for word operations.
  final WordStorage storage;

  /// Constructs a [Dictionary] instance with the given parameters.
  ///
  /// [value] The total value associated with the words in the dictionary.
  /// [alphabet] The alphabet used in the words of the dictionary.
  /// [joker] The symbol representing any character in the alphabet.
  /// [storage] The storage used for word operations.
  Dictionary({
    required super.value,
    required super.alphabet,
    required super.joker,
    required super.maxWordLength,
    required this.storage,
  });

  /// A [Dictionary] with 0 value, '*' joker character
  /// and with the english alphabet.
  ///
  /// [storage] The storage used for word operations.
  Dictionary.english(this.storage, {int? maxWordLength})
      : super(value: 0, joker: '*', maxWordLength: maxWordLength ?? 45, alphabet:
       const [
          'a',
          'b',
          'c',
          'd',
          'e',
          'f',
          'g',
          'h',
          'i',
          'j',
          'k',
          'l',
          'm',
          'n',
          'o',
          'p',
          'q',
          'r',
          's',
          't',
          'u',
          'v',
          'w',
          'x',
          'y',
          'z'
        ]);

  Future<Word?> lookupText(String text) async {
    final Word? found = await storage.lookup(text);
    return found;
  }

  /// Checks if the provided [text] is too long for the [Dictionary] to store.
  bool isTextTooLong(String text) {
    return text.length > maxWordLength;
  }

  /// Checks if the provided [text] contains any characters not included in the
  /// [Dictionary]'s alphabet.
  bool hasInvalidChar(String text) {
    return text.runes
        .any((int letter) => !alphabet.asRunes().contains(letter));
  }
}
