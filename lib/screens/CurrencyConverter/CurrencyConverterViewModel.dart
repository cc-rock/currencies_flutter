import 'dart:async';
import 'dart:developer' as developer;

import 'package:async/async.dart';
import 'package:built_collection/built_collection.dart';
import 'package:currencies/domain/entities.dart';
import 'package:currencies/domain/repositories.dart';
import 'package:currencies/screens/CurrencyConverter/CurrencyConverterViewState.dart';
import 'package:currencies/utils/cancellables.dart';

import '../ViewModel.dart';

class CurrencyConverterViewModel extends ViewModel<CurrencyConverterViewState> {

  final CurrencyRepository _currencyRepo;
  final ConversionRateRepository _ratesRepo;

  int _counter = 0;

  CurrencyConverterViewState get _initialState => CurrencyConverterViewState((b) => b
    ..loading = true
    ..build()
  );

  CurrencyConverterViewModel(
      this._currencyRepo,
      this._ratesRepo,
      StreamController<CurrencyConverterViewState> Function() scFactory
  ): super(scFactory) {
    pushState(_initialState);
    _currencyRepo.getConverterBase().then((converterBase) {
      _currencyRepo.getCurrencies().then((currencies) {
        pushState(CurrencyConverterViewState((b) => b
          ..inputTextLabel = converterBase.name
          ..rows = _allWithAmount(converterBase, currencies, "")
        ));
      });
    }).catchError((error) {
      pushState(_getErrorState(error));
    });
  }
  
  void onAmountTextChanged(String amountText) {
    compCanc.cancel();
    _fetchRatesAndComputeAmounts(amountText);
  }

  Future _fetchRatesAndComputeAmounts(String amountText) async {
    int countz = _counter++;
    developer.log("Inizio $countz");
    Currency converterBase;
    List<Currency> currencies;
    try {
      await compCanc.add(Future.delayed(Duration(milliseconds: 300)));
      developer.log("Dopo wait $countz");
      double amount = double.parse(amountText, (_) => -1);
      Currency converterBase = await compCanc.add(_currencyRepo.getConverterBase());
      List<Currency> currencies = await compCanc.add(_currencyRepo.getCurrencies());
      if (amount < 0) {
        developer.log("push error $countz");
        pushState(CurrencyConverterViewState((b) => b
          ..inputTextLabel = converterBase.name
          ..rows = _allWithAmount(converterBase, currencies, "ERROR")
        ));
      } else {
        developer.log("push loading $countz");
        pushState(CurrencyConverterViewState((b) =>
        b
          ..inputTextLabel = converterBase.name
          ..rows = _allWithAmount(converterBase, currencies, "LOADING")
        ));
        developer.log("Prima di rates $countz");
        List<ConversionRate> rates = await compCanc.add(_ratesRepo.getLatestConversionRates(converterBase, currencies));
        developer.log("dopo rates $countz");
        pushState(CurrencyConverterViewState((b) => b
          ..inputTextLabel = converterBase.name
          ..rows = ListBuilder(currencies.where((curr) => curr != converterBase).map((curr) =>
              CurrencyConverterRow((br) =>
              br
                ..currencyLabel = curr.name
                ..selected = false
                ..amount = (rates
                    .firstWhere((rate) => rate.to == curr)
                    .rate * amount).toString()
              ))
          )
        ));
        developer.log("dopo push rates $countz");
      }
    } catch (error) {
      if (error is CancellationException) {
        developer.log("Cancelled $countz");
        return;
      }
      developer.log("Push errorino $countz");
      developer.log(error.toString());
      if (converterBase != null && currencies != null) {
        developer.log("Push errorino proprio $countz");
        pushState(CurrencyConverterViewState((b) => b
          ..inputTextLabel = converterBase.name
          ..rows = _allWithAmount(converterBase, currencies, "ERRORINO")
        ));
      }
    }
  }

  ListBuilder<CurrencyConverterRow> _allWithAmount(Currency base, List<Currency> currencies, String amount) =>
    ListBuilder(currencies.where((curr) => curr != base).map((curr) => CurrencyConverterRow((br) => br
      ..currencyLabel = curr.name
      ..selected = false
      ..amount = amount
    )));
  
  CurrencyConverterViewState _getErrorState(Object error) => CurrencyConverterViewState((b) => b
    ..errorMessage = error.toString()
  );

}

