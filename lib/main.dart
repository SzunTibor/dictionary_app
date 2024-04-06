import 'package:dictionary_app_cont/di/di_container.dart';
import 'package:dictionary_app_cont/di/di_initializer.dart';
import 'package:flutter/material.dart';

import 'presentation/DictionaryApp.dart';

void main() {
  initGetIt(di);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DictionaryApp());
}
