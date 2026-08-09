import 'package:test/test.dart';
import 'package:wasm/boutiquescore.dart';

void main() {
  group('buildSubmitPayload', () {
    test('store-only payload has Q1–Q5 and loan, no score', () {
      final input = EvaluationInput(
        contact: PhoneContact(
          phone: const PhoneNumber(countryCode: 237, number: '690000000'),
          country: const CountryInfo(code2Letters: 'CM', namel10n: 'Cameroun'),
          city: 'Douala',
        ),
        diagnostic: BusinessDiagnostic(
          activityIsicCode: '1071',
          isRegistered: true,
          shopTenure: ShopTenure.oneToThreeYears,
          supplierCredit: SupplierCredit.shortTerm,
          cashSeparation: CashSeparation.fixedSalaryOrLogged,
          customerCreditTracking: CustomerCreditTracking.paperNotebook,
          restockFrequency: RestockFrequency.oneToTwoPerWeek,
          wantsMfiLoan: true,
          requestedLoanAmount: const MoneyAmount(
            amountMinor: 250000,
            currencyCode: 'XAF',
          ),
          registration: const RegistrationDetails(
            commercialRegisterNumber: 'RC/DLA/2020/B/123',
            legalFormCode: LegalFormCode.sarl,
          ),
        ),
        campaignId: 'cameroon_pilot_2026',
        mfiPartnerId: 'mfi_douala_01',
      );

      final payload = buildSubmitPayload(input);

      expect(payload.containsKey('score'), isFalse);
      expect(payload.containsKey('financialHealthScore'), isFalse);
      expect(payload.containsKey('recommendation'), isFalse);

      final diagnostic = payload['diagnostic']! as Map<String, Object?>;
      expect(diagnostic['shopTenure'], 'ONE_TO_THREE_YEARS');
      expect(diagnostic['supplierCredit'], 'SHORT_TERM');
      expect(diagnostic['cashSeparation'], 'FIXED_SALARY_OR_LOGGED');
      expect(diagnostic['customerCreditTracking'], 'PAPER_NOTEBOOK');
      expect(diagnostic['restockFrequency'], 'ONE_TO_TWO_PER_WEEK');
      expect(diagnostic['wantsMfiLoan'], isTrue);
      expect(
        (diagnostic['requestedLoanAmount'] as Map)['currencyCode'],
        'XAF',
      );
      expect(
        (diagnostic['requestedLoanAmount'] as Map)['amountMinor'],
        250000,
      );
      expect(diagnostic.containsKey('approximateDailyRevenue'), isFalse);
      expect(diagnostic.containsKey('recordMethod'), isFalse);
    });
  });

  group('DialCodes', () {
    test('CM and ML prefixes', () {
      expect(DialCodes.forCountry('CM'), 237);
      expect(DialCodes.displayPrefix('ML'), '+223');
    });
  });

  group('parseLoanAmount', () {
    test('parses free text with country currency', () {
      final money = parseLoanAmount(countryIso2: 'CM', rawAmount: '250 000');
      expect(money, isNotNull);
      expect(money!.amountMinor, 250000);
      expect(money.currencyCode, 'XAF');
    });

    test('GN uses GNF', () {
      final money = parseLoanAmount(countryIso2: 'GN', rawAmount: '1000000');
      expect(money!.currencyCode, 'GNF');
    });

    test('empty returns null', () {
      expect(parseLoanAmount(countryIso2: 'CM', rawAmount: ''), isNull);
    });
  });
}
