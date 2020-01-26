import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:currencies/domain/repositories.dart';
import 'package:currencies/screens/CurrencyConverter/CurrencyConverterViewState.dart';
import 'package:rxdart/rxdart.dart';

class CurrencyConverterViewModel {

  final _subject = BehaviorSubject<CurrencyConverterViewState>.seeded(_initialState);

  Stream<CurrencyConverterViewState> get stream {
    return _subject.stream;
  }

  CurrencyConverterViewState get currentState {
    return _subject.value;
  }

  final CurrencyRepository _currencyRepo;
  final ConversionRateRepository _ratesRepo;

  CurrencyConverterViewModel(this._currencyRepo, this._ratesRepo) {
    _currencyRepo.getConverterBase().then((converterBase) {
      _currencyRepo.getCurrencies().then((currencies) {
        _subject.add(CurrencyConverterViewState((b) => b
          ..loading = false
          ..inputText = ""
          ..inputTextLabel = converterBase.name
          ..compareButtonEnabled = false
          ..rows = ListBuilder(currencies.where((curr) => curr != converterBase).map((curr) => CurrencyConverterRow((br) => br
              ..loading = true
              ..currencyLabel = curr.name
              ..selected = false
              ..amount = ""
              ..build()
            ))
          )
          ..build()
        ));
      });
    }).catchError((error) {
      _subject.addError(error);
    });
  }

}

final _initialState = CurrencyConverterViewState((b) => b
  ..loading = true
  ..inputText = ""
  ..inputTextLabel = ""
  ..compareButtonEnabled = false
  ..rows = ListBuilder([])
  ..build()
);
