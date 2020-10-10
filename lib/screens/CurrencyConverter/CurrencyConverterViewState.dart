import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'CurrencyConverterViewState.g.dart';

abstract class CurrencyConverterViewState implements Built<CurrencyConverterViewState, CurrencyConverterViewStateBuilder> {

  bool get loading;
  String get inputText;
  String get inputTextLabel;
  BuiltList<CurrencyConverterRow> get rows;
  bool get compareButtonEnabled;
  @nullable String get errorMessage;

  CurrencyConverterViewState._();

  factory CurrencyConverterViewState([void applyBuilder(CurrencyConverterViewStateBuilder updates)]) = _$CurrencyConverterViewState;

  static void _initializeBuilder(CurrencyConverterViewStateBuilder builder) => builder
      ..loading = false
      ..inputText = ""
      ..inputTextLabel = ""
      ..rows = ListBuilder([])
      ..compareButtonEnabled = false;

}

abstract class CurrencyConverterRow implements Built<CurrencyConverterRow, CurrencyConverterRowBuilder> {

  String get currencyLabel;
  String get amount;
  bool get selected;

  CurrencyConverterRow._();

  factory CurrencyConverterRow([void applyBuilder(CurrencyConverterRowBuilder updates)]) = _$CurrencyConverterRow;

}