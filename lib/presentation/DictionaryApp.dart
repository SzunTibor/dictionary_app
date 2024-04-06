import 'package:dictionary_app_cont/presentation/navigation/app_scaffold.dart';
import 'package:flutter/material.dart';

class DictionaryApp extends StatelessWidget {
  const DictionaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AppScaffold(),
      ),
    );
  }
}
