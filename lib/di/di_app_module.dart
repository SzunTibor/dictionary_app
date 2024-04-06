import 'package:dictionary_app_cont/domain/domain_api.dart';
import 'package:flutter/material.dart';

abstract class DIAppModule {
  static GlobalKey<NavigatorState> get navKey => GlobalKey<NavigatorState>();
  static GlobalKey<ScaffoldState> get scaffoldKey => GlobalKey<ScaffoldState>();
  static List<Word> get localWordsList => [];
}
