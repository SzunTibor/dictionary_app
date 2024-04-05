import 'dart:async';

import '../domain_api.dart';

/// A text processor that takes a list of text and converts them into [Word]s.
abstract interface class TextProcessor {
  FutureOr<Response<List<Word>>> processText(Iterable<String> text);
}
