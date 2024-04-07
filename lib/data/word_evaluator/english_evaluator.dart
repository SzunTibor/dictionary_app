// import 'dart:async';

// import '../../domain/models/word.dart';
// import '../word_storage/map_storage.dart';
// import 'word_evaluator.dart';

// class EnglishEvaluator implements WordEvaluator {
//   late final MapWordStorage _storage;

//   bool _initialized = false;
//   bool get isInitialized => _initialized;

//   @override
//   FutureOr<void> initialize() async {
//     _storage = MapWordStorage();

//     for (var word in words) {
//       _storage.save(
//           Word(text: word, value: word.length, state: WordState.accepted));
//     }

//     _initialized = true;
//   }

//   @override
//   FutureOr<int> evaluate(String word) async {
//     assert(isInitialized, 'Evaluator must be initialized first.');

//     final Word? found = await _storage.lookup(word);

//     if (found == null) {
//       return 0;
//     } else {
//       return found.value;
//     }
//   }
// }
