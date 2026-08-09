import 'package:country_currency_iso/country_currency_iso.dart';

/// Resolves ISO 4217 currency for a country (Africa-first via country_currency_iso).
String? currencyForCountryIso(String countryCode) =>
    currencyForCountry(countryCode);

/// Fallback when the package has no mapping (should be rare for our form countries).
String requireCurrencyForCountry(String countryCode, {String fallback = 'XAF'}) {
  return currencyForCountry(countryCode) ?? fallback;
}
