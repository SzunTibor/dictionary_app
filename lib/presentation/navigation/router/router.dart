import 'package:flutter/material.dart';

class DictionaryRouter {
  const DictionaryRouter(this._navigatorKey);

  final GlobalKey<NavigatorState> _navigatorKey;

  static const initialRoute = '/input';

  Future<void> pushNamed(String routeName) =>
      _navigatorKey.currentState!.pushNamed(routeName);

  Route<MaterialPageRoute>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == null) {
      return null;
    }

    final uri = Uri.parse(settings.name!);
    final pathSegments = uri.pathSegments;
    if (pathSegments.isEmpty) {
      return null;
    }

    // if (pathSegments.first == 'input') {
    //   return MaterialPageRoute(
    //     builder: (context) => InputPage(),
    //   );
    // }

    // if (pathSegments.first == 'results') {
    //   return MaterialPageRoute(
    //     builder: (context) => ResultsPage(),
    //   );
    // }

    return null;
  }
}
