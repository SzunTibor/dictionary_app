import 'package:dictionary_app_cont/di/di_container.dart';
import 'package:dictionary_app_cont/presentation/navigation/navigator.dart';
import 'package:dictionary_app_cont/presentation/snackbar/SnackBarManager.dart';
import 'package:flutter/material.dart';

import '../snackbar/SnackBarService.dart';
import 'router/router.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  final DictionaryNavigator navigator = di<DictionaryNavigator>();
  final DictionaryRouter router = di<DictionaryRouter>();

  int screenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: screenIndex,
        destinations: navigator.destinations,
        onDestinationSelected: (index) {
          setState(() {
            screenIndex = index;
          });
          navigator.destinations[index].callback();
        },
      ),
      body: SnackBarManager(
        snackBarService: di<SnackBarService>(),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints.loose(const Size.fromWidth(769)),
            child: Navigator(
              key: di<GlobalKey<NavigatorState>>(),
              initialRoute: '/input',
              onGenerateRoute: router.onGenerateRoute,
            ),
          ),
        ),
      ),
    );
  }
}
