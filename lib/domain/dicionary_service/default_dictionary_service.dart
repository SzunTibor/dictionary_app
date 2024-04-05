import 'dart:async';

import '../domain_api.dart';

/// Default implementation of a service for interacting with a [Dictionary].
class DefaultDictionaryService implements DictionaryService {
  final Dictionary _dictionary;

  /// Creates a new service to interact with a [Dictionary].
  ///
  /// Without any parameters it will use an english dictionary with a
  /// [MapWordStorage] as storage.
  /// If [dictionary] is provided it will be used instead and [storage]
  /// parameter will be ignored.
  /// If [dictionary] is null and [storage] is provided it will be
  /// used instead of the default for an english dictionary.
  DefaultDictionaryService({Dictionary? dictionary, WordStorage? storage})
      : _dictionary =
            dictionary ?? Dictionary.english(storage ?? MapWordStorage());

  /// The dictionary information.
  @override
  DictionaryInfo get dictionaryInfo => _dictionary;

  /// Filters words in the dictionary by the given [prefix].
  ///
  /// A [Response.success] contains a list of [Word]s filtered by the prefix.
  @override
  FutureOr<Response<List<Word>>> filterBy(String prefix) async {
    if (_dictionary.isTextTooLong(prefix)) {
      return Response.warning(
          'The Dictionary cannot store such a long word.', []);
    }
    if (_dictionary.hasInvalidChar(prefix)) {
      return Response.warning('The prefix has invalid characters.', []);
    }

    try {
      final List<Word> result = await _dictionary.storage.query(prefix);
      return Response.success(result);
    } catch (error) {
      return Response.error(error.toString(), []);
    }
  }

  /// Saves a list of [words] to the dictionary.
  ///
  /// If there are [Word]s rejected by the [Dictionary], they are returned in a
  /// list.
  /// Words already in the dictionary, with equal or less value than in the
  /// dictionary will be skipped.
  /// Dictionary's value will be updated by the saved word's total value.
  @override
  FutureOr<Response<List<Word>>> saveWords(List<Word> words) async {
    assert(!words.any((word) => word.state == WordState.pending),
        'One or more words are still pending.');

    // Filter out words rejected by the dictionary.
    final List<Word> wordsAccepted;
    final List<Word> wordsRejected;

    (accepted: wordsAccepted, rejected: wordsRejected) =
        _dictionary.filterOutRejected(words);

    // Dont overwrite duplicate words.
    final List<Word> wordsToSave = [];
    try {
      await _filterOutDuplicates(wordsAccepted, wordsToSave);
    } catch (error) {
      return Response.error(error.toString(), []);
    }

    // Save the words. Return rejected words.
    try {
      await _dictionary.storage.saveAll(wordsToSave);
      // Update dictionary total value.
      final int valueGained = wordsToSave.fold<int>(0, (a, c) => a + c.value);
      _dictionary.value += valueGained;

      if (wordsRejected.isNotEmpty) {
        return Response(
            type: ResponseType.warning,
            message: 'Word(s) were rejected by the dictionary.',
            value: wordsRejected);
      }

      return Response.success([]);
    } catch (error) {
      return Response.error(error.toString(), []);
    }
  }

  Future<void> _filterOutDuplicates(List<Word> input, List<Word> output) async {
    for (Word word in input) {
      final Word? found = await _dictionary.lookupText(word.text);
      if (found == null || word.value > found.value) output.add(word);
    }
  }
}
