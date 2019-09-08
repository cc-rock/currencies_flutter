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

  test("The request for the latest rates throws exception if the http request is not successful", () {
    when(response.statusCode).thenReturn(404);
    when(response.data).thenReturn("TestError");
    expect(
        fixerApi.getLatestConversionRates("USD", ["CAD", "CHF", "EUR", "GBP"]),
        throwsA(predicate((it) => (it is FixerHttpException && it.message == "TestError" && it.statusCode == 404)))
    );
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