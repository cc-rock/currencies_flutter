import 'dart:async';

import 'package:currencies/boundary/data/currency_repo.dart';
import 'package:currencies/boundary/data/fixer_api.dart';
import 'package:currencies/boundary/data/fixer_rates_repo.dart';
import 'package:currencies/screens/CurrencyConverter/CurrencyConverterScreen.dart';
import 'package:currencies/screens/CurrencyConverter/CurrencyConverterViewModel.dart';
import 'package:dio/dio.dart';
import 'package:injector/injector.dart';

import 'domain/repositories.dart';

Injector createInjector() {
  Injector injector = Injector();

  injector
      .registerDependency<CurrencyRepository>((_) => CurrencyRepositoryImpl());
  injector.registerDependency<Dio>((_) => Dio());
  injector.registerDependency<FixerApi>(
      (injector) => FixerApi(injector.getDependency<Dio>()));
  injector.registerDependency<ConversionRateRepository>((injector) =>
      FixerConversionRateRepository(injector.getDependency<FixerApi>()));

  injector.registerDependency<CurrencyConverterViewModel>((i) =>
      CurrencyConverterViewModel(
          i.getDependency<CurrencyRepository>(),
          i.getDependency<ConversionRateRepository>(),
          () => StreamController()
      )
  );

  injector.registerSingleton<CurrencyConverterScreen>((i) => CurrencyConverterScreen(i.getDependency<CurrencyConverterViewModel>()));

  return injector;
}
