import 'dart:async';

import '../../domain/models/word.dart';
import 'word_storage.dart';

/// A storage that implements [WordStorage] interface and uses a Map as storage.
class MapWordStorage implements WordStorage {
  // Internal storage using a Map with word text as key and Word object as value
  final Map<String, Word> _storage = <String, Word>{};

  @override
  int get size => _storage.length;

  /// Looks up a [word] in the storage.
  ///
  /// Returns the corresponding [Word].
  /// Returns 'null' if the word is not found in the storage.
  @override
  FutureOr<Word?> lookup(String word) {
    return _storage[word];
  }

  /// Queries the storage for words with the given [prefix].
  ///
  /// Returns an ascending sorted list of matching [Word]s.
  /// Returns an empty list if no words match the given prefix.
  @override
  FutureOr<List<Word>> query(String prefix) {
    final List<Word> result = [];

    _storage.keys
        .where((key) => key.startsWith(prefix))
        .forEach((match) => result.add(_storage[match]!));

    result.sort((a, b) => a.text.compareTo(b.text));

    return result;
  }

  /// Saves a single [Word] to the storage.
  ///
  /// Overwrites any existing word with the same text in the storage.
  @override
  FutureOr<void> save(Word word) {
    _storage[word.text] = word;
  }

  /// Saves a list of [Word]s to the storage.
  ///
  /// Overwrites any existing words with the same text in the storage.
  @override
  FutureOr<void> saveAll(List<Word> words) {
    for (var word in words) {
      save(word);
    }
  }
}
