import 'package:currencies/injector.dart';
import 'package:currencies/screens/CurrencyConverter/CurrencyConverterScreen.dart';
import 'package:flutter/material.dart';

var injector = createInjector();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currencies',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: injector.getDependency<CurrencyConverterScreen>()
    );
  }
}

