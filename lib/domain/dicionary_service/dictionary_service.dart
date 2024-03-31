import 'dart:async';

import '../models/dictionary_info.dart';
import '../models/word.dart';
import '../response.dart';

/// An interface representing operations for interacting with a dictionary.
abstract interface class DictionaryService {
  /// Gets the dictionary information.
  DictionaryInfo get dictionaryInfo;

  /// Filters words in the dictionary by the given [prefix].
  /// 
  /// A success response containing a list of [Word]s filtered by the prefix.
  FutureOr<Response<List<Word>>> filterBy(String prefix);

  /// Saves a list of [words] to the dictionary.
  FutureOr<Response<void>> saveWords(List<Word> words);
}
