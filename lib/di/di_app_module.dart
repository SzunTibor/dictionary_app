import 'package:flutter/material.dart';

abstract class DIAppModule {
  static GlobalKey<NavigatorState> get navKey => GlobalKey<NavigatorState>();
}
