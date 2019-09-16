import 'package:currencies/boundary/data/fixer_api.dart';
import 'package:currencies/domain/entities.dart';
import 'package:currencies/domain/repositories.dart';

class FixerConversionRateRepository implements ConversionRateRepository {

  FixerApi _fixerApi;

  FixerConversionRateRepository(this._fixerApi);

  @override
  Future<List<ConversionRate>> getHistoricalConversionRates(Currency base, List<Currency> targets, DateTime date) async {
    FixerResponse response = await _fixerApi.getHistoricalConversionRates(base.name, targets.map((currency) => currency.name), date);
    return _convertResponse(response, base, targets);
  }

  @override
  Future<List<ConversionRate>> getLatestConversionRates(Currency base, List<Currency> targets) async {
    FixerResponse response = await _fixerApi.getLatestConversionRates(base.name, targets.map((currency) => currency.name));
    return _convertResponse(response, base, targets);
  }

  List<ConversionRate> _convertResponse(FixerResponse response, Currency base, List<Currency> targets) {
    if (base.name != response.base) {
      throw new Exception("Invalid fixer response: wrong base");
    }
    return response.rates.entries.map((entry) =>
        _ConversionRateImpl(
          base,
          targets.singleWhere((currency) => currency.name == entry.key),
          entry.value,
          DateTime.parse(response.date)
        )
    ).toList();
  }

}

class _ConversionRateImpl implements ConversionRate {

  final Currency _from;
  final Currency _to;
  final double _rate;
  final DateTime _date;

  const _ConversionRateImpl(
      this._from,
      this._to,
      this._rate,
      this._date
  );

  @override
  Currency get from => null;

  @override
  Currency get to => null;

  @override
  DateTime get date => null;

  @override
  double get rate => null;

}