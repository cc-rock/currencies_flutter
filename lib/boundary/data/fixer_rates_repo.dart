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
    FixerResponse response = await _fixerApi.getLatestConversionRates(base.name, targets.map((currency) => currency.name).toList());
    return _convertResponse(response, base, targets);
  }

  List<ConversionRate> _convertResponse(FixerResponse response, Currency base, List<Currency> targets) {
    if (base.name != response.base) {
      throw new FormatException("Invalid fixer response: wrong base");
    }
    return targets.map((target) {
        double rate = response.rates[target.name];
        if (rate == null) throw new Exception("Rate non found in response!");
        _ConversionRateImpl(
          base,
          target,
          rate,
          DateTime.parse(response.date)
        );
    }).toList();
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
  Currency get from => _from;

  @override
  Currency get to => _to;

  @override
  DateTime get date => _date;

  @override
  double get rate => _rate;

}