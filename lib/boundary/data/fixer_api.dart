import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:currencies/domain/entities.dart';
import 'package:dio/dio.dart';

part 'fixer_api.g.dart';

class FixerApi {

  static const String _API_KEY = "b90617e77d89b12cfebeb90018c45b95";
  static const String _BASE_URL = "https://data.fixer.io/api";
  static const String _LATEST_ENDPOINT = "latest";

  Dio _dio;

  FixerApi(this._dio);

  Future<FixerResponse> getHistoricalConversionRates(Currency base, List<Currency> targets, DateTime date) {
    String formattedDate = "${date.toIso8601String().substring(0,10)}";
    return _getConversionRates(formattedDate, base, targets);
  }

  Future<FixerResponse> getLatestConversionRates(Currency base, List<Currency> targets) {
    return _getConversionRates(_LATEST_ENDPOINT, base, targets);
  }

  Future<FixerResponse> _getConversionRates(String dateOrLatest, Currency base, List<Currency> targets) async {
    Response<String> response = await _dio.get(
      "$_BASE_URL/$dateOrLatest", 
      queryParameters: {
        "access_key": _API_KEY, 
        "base": base.name, 
        "symbols": targets.fold("", (acc, val) => "$acc,${val.name}")
      }
    );
    if ([200, 203].contains(response.statusCode)) {
      return _serializers.deserialize(json.decode(response.data));
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
  @nullable
  bool get historical;
  DateTime get date;
  int get timestamp;
  String get base;
  Map<String, double> get rates;

  FixerResponse._();
  factory FixerResponse([void applyBuilder(FixerResponseBuilder updates)]) = _$FixerResponse;
}

@SerializersFor(const [
  FixerResponse
])

Serializers _serializers = _$_serializers;