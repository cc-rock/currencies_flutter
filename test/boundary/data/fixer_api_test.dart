import 'package:currencies/boundary/data/fixer_api.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockDio extends Mock implements Dio {}
class MockResponse extends Mock implements Response<String> {}

void main() {

  Dio dio;
  Response<String> response;
  FixerApi fixerApi;

  setUp(() {
    dio = MockDio();
    fixerApi = FixerApi(dio);
    response = MockResponse();
    when(dio.get<String>(any, queryParameters: anyNamed("queryParameters"))).thenAnswer((_) => Future.value(response));
  });

  test("The request for the latest rates is constructed correctly", () {
    when(response.statusCode).thenReturn(200);
    when(response.data).thenReturn(testResponse);
    fixerApi.getLatestConversionRates("USD", ["CAD", "CHF", "EUR", "GBP"]);
    Map<String, dynamic> queryParams = verify(dio.get(
        argThat(endsWith("/latest")),
        queryParameters: captureAnyNamed("queryParameters")
    )).captured.single;
    expect(queryParams["access_key"], isNotEmpty);
    expect(queryParams["base"], "USD");
    expect(queryParams["symbols"], "CAD,CHF,EUR,GBP");
  });

  test("The request for the latest rates throws exception if the http request code is 404", () {
    when(response.statusCode).thenReturn(404);
    when(response.data).thenReturn("TestError");
    expect(
        fixerApi.getLatestConversionRates("USD", ["CAD", "CHF", "EUR", "GBP"]),
        throwsA(predicate((it) => (it is FixerHttpException && it.message == "TestError" && it.statusCode == 404)))
    );
  });

  test("The request for the latest rates throws exception if the http request code is 401", () {
    when(response.statusCode).thenReturn(401);
    when(response.data).thenReturn("TestError");
    expect(
        fixerApi.getLatestConversionRates("USD", ["CAD", "CHF", "EUR", "GBP"]),
        throwsA(predicate((it) => (it is FixerHttpException && it.message == "TestError" && it.statusCode == 401)))
    );
  });

  test("The request for the latest rates throws exception if the http request code is 500", () {
    when(response.statusCode).thenReturn(500);
    when(response.data).thenReturn("TestError");
    expect(
        fixerApi.getLatestConversionRates("USD", ["CAD", "CHF", "EUR", "GBP"]),
        throwsA(predicate((it) => (it is FixerHttpException && it.message == "TestError" && it.statusCode == 500)))
    );
  });

  test("The response of the latest rates is parsed and returned if the http code is 200", () async {
    when(response.statusCode).thenReturn(200);
    when(response.data).thenReturn(testResponse);
    FixerResponse result = await fixerApi.getLatestConversionRates("USD", ["CAD", "CHF", "EUR", "GBP"]);
    expect(result, isNotNull);
  });

  test("The response of the latest rates is parsed correctly", () async {
    when(response.statusCode).thenReturn(200);
    when(response.data).thenReturn(testResponse);
    FixerResponse result = await fixerApi.getLatestConversionRates("USD", ["CAD", "CHF", "EUR", "GBP"]);
    expect(result.success, true);
    expect(result.timestamp, 1519296206);
    expect(result.base, "USD");
    expect(result.date, "2018-02-13");
    expect(result.historical, isNull);
    expect(result.rates.length, 4);
    expect(result.rates["CAD"], 1.260046);
    expect(result.rates["CHF"], 0.933058);
    expect(result.rates["EUR"], 0.806942);
    expect(result.rates["GBP"], 0.719154);
  });

  test("The request for the historical rates is constructed correctly", () {
    when(response.statusCode).thenReturn(200);
    when(response.data).thenReturn(testResponse);
    fixerApi.getHistoricalConversionRates("USD", ["CAD", "CHF", "EUR", "GBP"], DateTime(2018, 2, 13));
    Map<String, dynamic> queryParams = verify(dio.get(
        argThat(endsWith("/2018-02-13")),
        queryParameters: captureAnyNamed("queryParameters")
    )).captured.single;
    expect(queryParams["access_key"], isNotEmpty);
    expect(queryParams["base"], "USD");
    expect(queryParams["symbols"], "CAD,CHF,EUR,GBP");
  });

  test("The request for the historical rates throws exception if the http request code is 404", () {
    when(response.statusCode).thenReturn(404);
    when(response.data).thenReturn("TestError");
    expect(
        fixerApi.getHistoricalConversionRates("USD", ["CAD", "CHF", "EUR", "GBP"], DateTime(2018, 2, 13)),
        throwsA(predicate((it) => (it is FixerHttpException && it.message == "TestError" && it.statusCode == 404)))
    );
  });

  test("The request for the historical rates throws exception if the http request code is 401", () {
    when(response.statusCode).thenReturn(401);
    when(response.data).thenReturn("TestError");
    expect(
        fixerApi.getHistoricalConversionRates("USD", ["CAD", "CHF", "EUR", "GBP"], DateTime(2018, 2, 13)),
        throwsA(predicate((it) => (it is FixerHttpException && it.message == "TestError" && it.statusCode == 401)))
    );
  });

  test("The request for the historical rates throws exception if the http request code is 500", () {
    when(response.statusCode).thenReturn(500);
    when(response.data).thenReturn("TestError");
    expect(
        fixerApi.getHistoricalConversionRates("USD", ["CAD", "CHF", "EUR", "GBP"], DateTime(2018, 2, 13)),
        throwsA(predicate((it) => (it is FixerHttpException && it.message == "TestError" && it.statusCode == 500)))
    );
  });

  test("The response of the historical rates is parsed and returned if the http code is 200", () async {
    when(response.statusCode).thenReturn(200);
    when(response.data).thenReturn(testResponseHistorical);
    FixerResponse result = await fixerApi.getHistoricalConversionRates("USD", ["CAD", "CHF", "EUR", "GBP"], DateTime(2018, 2, 13));
    expect(result, isNotNull);
  });

  test("The response of the historical rates is parsed correctly", () async {
    when(response.statusCode).thenReturn(200);
    when(response.data).thenReturn(testResponseHistorical);
    FixerResponse result = await fixerApi.getHistoricalConversionRates("USD", ["CAD", "CHF", "EUR", "GBP"], DateTime(2018, 2, 13));
    expect(result.success, true);
    expect(result.timestamp, 1519296206);
    expect(result.base, "USD");
    expect(result.date, "2018-02-13");
    expect(result.historical, true);
    expect(result.rates.length, 4);
    expect(result.rates["CAD"], 1.260046);
    expect(result.rates["CHF"], 0.933058);
    expect(result.rates["EUR"], 0.806942);
    expect(result.rates["GBP"], 0.719154);
  });


}

String testResponse = """
{
  "success": true,
  "timestamp": 1519296206,
  "base": "USD",
  "date": "2018-02-13",
  "rates": {
     "CAD": 1.260046,
     "CHF": 0.933058,
     "EUR": 0.806942,
     "GBP": 0.719154
   }
}   
""";

String testResponseHistorical = """
{
  "success": true,
  "historical": true,
  "date": "2018-02-13",
  "timestamp": 1519296206,
  "base": "USD",
  "rates": {
     "CAD": 1.260046,
     "CHF": 0.933058,
     "EUR": 0.806942,
     "GBP": 0.719154
   }
}   
""";