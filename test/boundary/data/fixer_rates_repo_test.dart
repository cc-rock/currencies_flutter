import 'package:currencies/boundary/data/fixer_api.dart';
import 'package:currencies/boundary/data/fixer_rates_repo.dart';
import 'package:currencies/domain/entities.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockFixerResponse extends Mock implements FixerResponse {}
class MockFixerApi extends Mock implements FixerApi {}
class MockCurrency implements Currency {
  MockCurrency(this.name);
  String name;
}

void main() {

  FixerApi fixerApi;
  FixerResponse fixerResponse;
  FixerConversionRateRepository repo;

  setUp(() {
    fixerApi = MockFixerApi();
    fixerResponse = MockFixerResponse();
    repo = FixerConversionRateRepository(fixerApi);
  });

  test("Latest rates: an exception is thrown if the response contains a different base", () async {
    when(fixerResponse.base).thenReturn("Invalid");
    Currency base = MockCurrency("BASE");
    List<Currency> targets = [MockCurrency("TGT1"), MockCurrency("TGT2")];
    when(fixerApi.getLatestConversionRates("BASE", ["TGT1", "TGT2"])).thenAnswer((_) => Future.value(fixerResponse));
    expect(
        await repo.getLatestConversionRates(base, targets),
        throwsA(Exception("Invalid fixer response: wrong base"))
    );
  });

}