import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:dio/dio.dart';

part 'fixer_api.g.dart';

class FixerApi {

  static const String _API_KEY = "b90617e77d89b12cfebeb90018c45b95";
  static const String _BASE_URL = "https://data.fixer.io/api";
  static const String _LATEST_ENDPOINT = "latest";

  Dio _dio;

  FixerApi(this._dio);

  Future<FixerResponse> getHistoricalConversionRates(String baseCurrency, List<String> targetCurrencies, DateTime date) {
    String formattedDate = "${date.toIso8601String().substring(0,10)}";
    return _getConversionRates(formattedDate, baseCurrency, targetCurrencies);
  }

  Future<FixerResponse> getLatestConversionRates(String baseCurrency, List<String> targetCurrencies) {
    return _getConversionRates(_LATEST_ENDPOINT, baseCurrency, targetCurrencies);
  }

  Future<FixerResponse> _getConversionRates(String dateOrLatest, String baseCurrency, List<String> targetCurrencies) async {
    Response<String> response = await _dio.get(
      "$_BASE_URL/$dateOrLatest", 
      queryParameters: {
        "access_key": _API_KEY, 
        "base": baseCurrency,
        "symbols": targetCurrencies.join(",")
      }
    );
    if (response.statusCode == 200) {
      return _serializers.deserializeWith(FixerResponse.serializer, json.decode(response.data));
    }
    throw new FixerHttpException(response.statusCode, response.data);
  }

}

class FixerHttpException {
  final int statusCode;
  final String message;
  FixerHttpException(this.statusCode, this.message);
}

abstract class FixerResponse implements Built<FixerResponse, FixerResponseBuilder> {

  static Serializer<FixerResponse> get serializer => _$fixerResponseSerializer;

  bool get success;
  @nullable bool get historical;
  String get date;
  int get timestamp;
  String get base;
  BuiltMap<String, double> get rates;

  FixerResponse._();
  factory FixerResponse([void applyBuilder(FixerResponseBuilder updates)]) = _$FixerResponse;
}

@SerializersFor(const [
  FixerResponse
])

Serializers _serializers = (_$_serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();