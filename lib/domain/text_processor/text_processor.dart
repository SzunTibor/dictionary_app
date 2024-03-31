import 'dart:async';

import '../models/word.dart';
import '../response.dart';

abstract interface class TextProcessor {
  FutureOr<Response<List<Word>>> processText(String text);
}
