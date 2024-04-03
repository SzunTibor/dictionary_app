import 'router/router.dart';

class DictionaryNavigator {
  const DictionaryNavigator(this._router);

  final DictionaryRouter _router;

  Future<void> goToInputViw(String launchId) =>
      _router.pushNamed('/input');

  Future<void> goToResultsView(String articleId) =>
      _router.pushNamed('/results');
}
