import 'package:dictionary_app_cont/data/word_evaluator/english_evaluator.dart';
import 'package:dictionary_app_cont/di/di_app_module.dart';
import 'package:dictionary_app_cont/domain/domain_api.dart';
import 'package:dictionary_app_cont/presentation/input/bloc/input_bloc.dart';
import 'package:dictionary_app_cont/presentation/navigation/navigator.dart';
import 'package:dictionary_app_cont/presentation/navigation/router/router.dart';
import 'package:dictionary_app_cont/presentation/result/bloc/result_bloc.dart';
import 'package:dictionary_app_cont/presentation/snackbar/SnackBarService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt initGetIt(GetIt getIt) => getIt
  // Blocs
  ..registerFactory(
      () => ResultBloc(getIt<DictionaryService>(), getIt<SnackBarService>()))
  ..registerFactory(() => InputBloc(getIt<TextProcessor>(),
      getIt<DictionaryService>(), getIt<SnackBarService>()))

  // Services
  ..registerFactory<DictionaryService>(
      () => DefaultDictionaryService(dictionary: getIt<Dictionary>()))

  // Repos
  ..registerSingletonAsync<WordEvaluator>(() async {
    final evaluator = EnglishEvaluator();
    await evaluator.initialize(DIAppModule.wordListResolver, lazy: true);
    return evaluator;
  })
  ..registerSingletonWithDependencies<TextProcessor>(() => DefaultTextProcessor(
      dictionary: getIt<Dictionary>(), evaluator: getIt<WordEvaluator>()), dependsOn: [WordEvaluator])
  ..registerLazySingleton(
      () => Dictionary.english(getIt<WordStorage>(), maxWordLength: 45))
  ..registerFactory<WordStorage>(() => MapWordStorage())

  // SnackBar
  ..registerLazySingleton(() => SnackBarService())
  // Nav
  ..registerLazySingleton(() => DictionaryNavigator(getIt<DictionaryRouter>()))
  ..registerFactory(() => DictionaryRouter(getIt<GlobalKey<NavigatorState>>()))
  ..registerLazySingleton(() => DIAppModule.navKey);
