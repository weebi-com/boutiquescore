import 'package:test/test.dart';
import 'package:boutiquescore/boutiquescore.dart';

void main() {
  group('currency_resolver', () {
    test('maps CM / SN / GN / CD to expected currencies', () {
      expect(currencyForCountryIso('CM'), 'XAF');
      expect(currencyForCountryIso('cm'), 'XAF');
      expect(currencyForCountryIso('SN'), 'XOF');
      expect(currencyForCountryIso('GN'), 'GNF');
      expect(currencyForCountryIso('CD'), 'CDF');
    });

    test('requireCurrencyForCountry falls back', () {
      expect(requireCurrencyForCountry('XX', fallback: 'XAF'), 'XAF');
    });
  });
}
