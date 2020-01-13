import 'package:built_collection/built_collection.dart';
import 'package:currencies/boundary/data/fixer_api.dart';
import 'package:currencies/boundary/data/fixer_rates_repo.dart';
import 'package:currencies/domain/entities.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockFixerApi extends Mock implements FixerApi {}
class MockCurrency implements Currency {
  MockCurrency(this.name);
  String name;
}

void main() {

  FixerApi fixerApi;
  FixerResponseBuilder fixerResponseBuilder;
  FixerConversionRateRepository repo;

  setUp(() {
    fixerApi = MockFixerApi();
    fixerResponseBuilder = FixerResponseBuilder()
      ..success = true
      ..historical = false
      ..date = ""
      ..timestamp = 0
      ..base = ""
      ..rates = BuiltMap<String, double>.of({}).toBuilder();
    repo = FixerConversionRateRepository(fixerApi);
  });

  test("Latest rates: an exception is thrown if the response contains a different base", () async {
    fixerResponseBuilder.base = "Invalid";
    FixerResponse fixerResponse = fixerResponseBuilder.build();
    Currency base = MockCurrency("BASE");
    List<Currency> targets = [MockCurrency("TGT1"), MockCurrency("TGT2")];
    when(fixerApi.getLatestConversionRates("BASE", ["TGT1", "TGT2"])).thenAnswer((_) => Future.value(fixerResponse));
    expect(
        repo.getLatestConversionRates(base, targets),
        throwsA(predicate((it) => (it is FormatException && it.message == "Invalid fixer response: wrong base")))
    );
  });

}