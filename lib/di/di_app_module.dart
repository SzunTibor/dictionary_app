import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class DIAppModule {
  static GlobalKey<NavigatorState> get navKey => GlobalKey<NavigatorState>();
  static Future<String> wordListResolver() async {
    return await rootBundle.loadString('assets/data/words_alpha.txt');
  }
}
