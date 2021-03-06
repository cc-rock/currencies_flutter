import 'entities.dart';

abstract class CurrencyRepository {
  Future<List<Currency>> getCurrencies();
  Future<Currency> getConverterBase();
}

abstract class ConversionRateRepository {
  Future<List<ConversionRate>> getLatestConversionRates(Currency base, List<Currency> targets);
  Future<List<ConversionRate>> getHistoricalConversionRates(Currency base, List<Currency> targets, DateTime date);
}