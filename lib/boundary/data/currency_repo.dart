import 'package:currencies/domain/entities.dart';
import 'package:currencies/domain/repositories.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {

  Future<List<Currency>> getCurrencies() {
    return Future.value([
      const _CurrencyImpl("EUR"),
      const _CurrencyImpl("USD"),
      const _CurrencyImpl("JPY"),
      const _CurrencyImpl("GBP"),
      const _CurrencyImpl("AUD"),
      const _CurrencyImpl("CAD"),
      const _CurrencyImpl("CHF"),
      const _CurrencyImpl("CNY"),
      const _CurrencyImpl("SEK"),
      const _CurrencyImpl("NZD"),
    ]);
  }

}

class _CurrencyImpl implements Currency {

  final String _name;
  const _CurrencyImpl(this._name);

  @override
  String get name => _name;

}