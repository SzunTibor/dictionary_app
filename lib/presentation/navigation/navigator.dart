import 'package:flutter/material.dart';

import 'router/router.dart';

class DictionaryNavigator {
  const DictionaryNavigator(this._router);

  final DictionaryRouter _router;

  Future<void> goToInputView() => _router.pushNamed('/input');

  Future<void> goToResultsView() => _router.pushNamed('/results');

  List<Destination> get destinations => [
        Destination(
            label: 'Input',
            icon: const Icon(Icons.keyboard_outlined),
            selectedIcon: const Icon(Icons.keyboard),
            callback: goToInputView),
        Destination(
            label: 'Result',
            icon: const Icon(Icons.list_outlined),
            selectedIcon: const Icon(Icons.list),
            callback: goToResultsView),
      ];
}

typedef NavAction = Future<void> Function();

class Destination extends NavigationDestination {
  const Destination(
      {super.key,
      required super.label,
      required super.icon,
      required super.selectedIcon,
      required this.callback});

  final NavAction callback;
}
