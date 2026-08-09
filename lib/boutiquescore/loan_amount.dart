import 'currency_resolver.dart';
import 'models.dart';

/// Parses a free-text loan amount into [MoneyAmount] using country → currency.
MoneyAmount? parseLoanAmount({
  required String countryIso2,
  required String rawAmount,
}) {
  final digits = rawAmount.replaceAll(RegExp(r'[^\d]'), '');
  if (digits.isEmpty) return null;
  final amount = int.tryParse(digits);
  if (amount == null || amount <= 0) return null;
  return MoneyAmount(
    amountMinor: amount,
    currency: requireCurrencyForCountry(countryIso2),
  );
}
