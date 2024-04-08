import 'dart:async';

import '../../domain/models/word.dart';
import '../word_storage/map_storage.dart';
import 'word_evaluator.dart';

/// A naive implementation of an evaluator that accepts words only listed in
/// a word list provided by a [resourceResolver].
class EnglishEvaluator implements WordEvaluator<FutureOr<String>> {
  late final MapWordStorage _storage;
  late final FutureOr<String> Function() _resolver;

  Completer<void>? _initialized;

  /// [resourceResolver] needs to be a list of english words,
  /// separated by whitespaces.
  /// It is possible to make initialization lazy, that is, only actually do
  /// it on the first [evaluate], by setting [lazy] to true.
  @override
  FutureOr<void> initialize(FutureOr<String> Function() resourceResolver,
      {bool lazy = false}) async {
    _storage = MapWordStorage();
    _resolver = resourceResolver;

    if (!lazy) await _initialize();
  }

  Future<void> _initialize() async {
    if (_initialized != null) return _initialized!.future;

    _initialized = Completer<void>();

    final words = (await _resolver()).split(RegExp(r'\s+'));

    for (var word in words) {
      _storage.save(
          Word(text: word, value: word.length, state: WordState.accepted));
    }

    _initialized!.complete();
  }

  @override
  FutureOr<int> evaluate(String word) async {
    await _initialize();

    final Word? found = await _storage.lookup(word);

    if (found == null) {
      return 0;
    } else {
      return found.value;
    }
  }
}
