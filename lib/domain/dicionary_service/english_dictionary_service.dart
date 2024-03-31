import 'dart:async';

import '../../data/word_storage/map_storage.dart';
import '../../data/word_storage/word_storage.dart';
import '../models/dictionary.dart';
import '../models/dictionary_info.dart';
import '../models/word.dart';
import '../response.dart';
import 'dictionary_service.dart';

/// A service for interacting with an English [Dictionary].
class EnglishDictionaryService implements DictionaryService {
  final Dictionary _dictionary;

  /// Creates a new service to interact with an english [Dictionary].
  ///
  /// If [storage] is provided it will be
  /// used instead of the default [MapWordStorage]-
  EnglishDictionaryService({WordStorage? storage})
      : _dictionary = Dictionary.english(storage ?? MapWordStorage());

  /// The dictionary information.
  @override
  DictionaryInfo get dictionaryInfo => _dictionary;

  /// Filters words in the dictionary by the given [prefix].
  ///
  /// A success response containing a list of [Word]s filtered by the prefix.
  @override
  FutureOr<Response<List<Word>>> filterBy(String prefix) async {
    try {
      final List<Word> result = await _dictionary.storage.query(prefix);
      return Response.success(result);
    } catch (error) {
      return Response.error(error.toString());
    }
  }

  /// Saves a list of [words] to the dictionary.
  @override
  FutureOr<Response<void>> saveWords(List<Word> words) async {
    try {
      await _dictionary.storage.saveAll(words);
      return Response.success(null);
    } catch (error) {
      return Response.error(error.toString());
    }
  }
}
