import 'package:currencies/boundary/data/fixer_api.dart';
import 'package:currencies/domain/entities.dart';
import 'package:currencies/domain/repositories.dart';

class FixerConversionRateRepository implements ConversionRateRepository {

  FixerApi _fixerApi;

  FixerConversionRateRepository(this._fixerApi);

  @override
  Future<List<ConversionRate>> getHistoricalConversionRates(Currency base, List<Currency> targets, DateTime date) async {
    FixerResponse response = await _fixerApi.getHistoricalConversionRates(base.name, targets.map((currency) => currency.name), date);
    return _convertResponse(response);
  }

  @override
  Future<List<ConversionRate>> getLatestConversionRates(Currency base, List<Currency> targets) async {
    // TODO: implement getLatestConversionRates
    return null;
  }

  List<ConversionRate> _convertResponse(FixerResponse response) {
    //return response.rates.entries.map((entry) => ConversionRate())
  }

}

class _ConversionRateImpl implements ConversionRate {
  @override
  // TODO: implement date
  DateTime get date => null;

  @override
  // TODO: implement from
  Currency get from => null;

  @override
  // TODO: implement rate
  double get rate => null;

  @override
  // TODO: implement to
  Currency get to => null;

}