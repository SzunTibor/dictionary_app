import 'dart:async';

import '../../domain/models/word.dart';


/// An interface representing storage operations for words.
abstract interface class WordStorage {
  /// The total number of words stored.
  int get size;

  /// Looks up a word in the storage and returns the
  /// corresponding [Word] or [Null] if not present.
  FutureOr<Word?> lookup(String word);

  /// Queries the storage for words with the given
  /// [prefix] and returns a list of matching [Word]s.
  FutureOr<List<Word>> query(String prefix);

  /// Saves a single [Word] to the storage.
  FutureOr<void> save(Word word);

  /// Saves a list of [Word]s to the storage.
  FutureOr<void> saveAll(List<Word> words);
}
