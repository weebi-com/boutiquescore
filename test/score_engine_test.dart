import 'package:test/test.dart';
import 'package:wasm/boutiquescore.dart';

BusinessDiagnostic _diag({
  ShopTenure tenure = ShopTenure.underOneYear,
  SupplierCredit supplier = SupplierCredit.cashOnly,
  CashSeparation cash = CashSeparation.mixedHousehold,
  CustomerCreditTracking credit = CustomerCreditTracking.memoryOnly,
  RestockFrequency restock = RestockFrequency.lessThanWeekly,
  bool wantsLoan = false,
  MoneyAmount? loan,
  bool registered = false,
}) {
  return BusinessDiagnostic(
    activityIsicCode: '4719',
    isRegistered: registered,
    shopTenure: tenure,
    supplierCredit: supplier,
    cashSeparation: cash,
    customerCreditTracking: credit,
    restockFrequency: restock,
    wantsMfiLoan: wantsLoan,
    requestedLoanAmount: loan,
  );
}

void main() {
  group('Q1–Q5 point tables', () {
    test('Q1 shop tenure', () {
      expect(RuleBasedScoreEngine.shopTenurePoints(ShopTenure.underOneYear), 5);
      expect(RuleBasedScoreEngine.shopTenurePoints(ShopTenure.oneToThreeYears), 12);
      expect(RuleBasedScoreEngine.shopTenurePoints(ShopTenure.overThreeYears), 20);
    });

    test('Q2 supplier credit', () {
      expect(RuleBasedScoreEngine.supplierCreditPoints(SupplierCredit.cashOnly), 5);
      expect(RuleBasedScoreEngine.supplierCreditPoints(SupplierCredit.shortTerm), 15);
      expect(
          RuleBasedScoreEngine.supplierCreditPoints(SupplierCredit.regularConsignment),
          25);
    });

    test('Q3 cash separation', () {
      expect(RuleBasedScoreEngine.cashSeparationPoints(CashSeparation.mixedHousehold), 5);
      expect(
          RuleBasedScoreEngine.cashSeparationPoints(CashSeparation.fixedSalaryOrLogged),
          18);
      expect(RuleBasedScoreEngine.cashSeparationPoints(CashSeparation.fullySeparated), 25);
    });

    test('Q4 customer credit tracking', () {
      expect(
          RuleBasedScoreEngine.customerCreditTrackingPoints(
              CustomerCreditTracking.memoryOnly),
          0);
      expect(
          RuleBasedScoreEngine.customerCreditTrackingPoints(
              CustomerCreditTracking.paperNotebook),
          10);
      expect(
          RuleBasedScoreEngine.customerCreditTrackingPoints(
              CustomerCreditTracking.dedicatedOrApp),
          15);
    });

    test('Q5 restock frequency', () {
      expect(
          RuleBasedScoreEngine.restockFrequencyPoints(RestockFrequency.lessThanWeekly),
          5);
      expect(
          RuleBasedScoreEngine.restockFrequencyPoints(RestockFrequency.oneToTwoPerWeek),
          10);
      expect(
          RuleBasedScoreEngine.restockFrequencyPoints(
              RestockFrequency.moreThanTwiceWeekly),
          15);
    });
  });

  group('RuleBasedScoreEngine', () {
    const engine = RuleBasedScoreEngine();

    test('minimum path sums to 20', () {
      // 5+5+5+0+5 = 20
      final result = engine.score(_diag());
      expect(result.score, 20);
      expect(result.recommendation, ActionRecommendation.unspecified);
    });

    test('maximum path sums to 100', () {
      final result = engine.score(
        _diag(
          tenure: ShopTenure.overThreeYears,
          supplier: SupplierCredit.regularConsignment,
          cash: CashSeparation.fullySeparated,
          credit: CustomerCreditTracking.dedicatedOrApp,
          restock: RestockFrequency.moreThanTwiceWeekly,
        ),
      );
      expect(result.score, 100);
    });

    test('loan ask does not change score', () {
      final without = engine.score(_diag());
      final withLoan = engine.score(
        _diag(
          wantsLoan: true,
          loan: const MoneyAmount(amountMinor: 500000, currencyCode: 'XAF'),
        ),
      );
      expect(withLoan.score, without.score);
    });

    test('credit opt-in threshold is 50', () {
      expect(kCreditOptInScoreThreshold, 50);
      expect(engine.score(_diag()).score, lessThanOrEqualTo(kCreditOptInScoreThreshold));
      expect(
        engine
            .score(
              _diag(
                tenure: ShopTenure.overThreeYears,
                supplier: SupplierCredit.regularConsignment,
                cash: CashSeparation.fullySeparated,
                credit: CustomerCreditTracking.dedicatedOrApp,
                restock: RestockFrequency.moreThanTwiceWeekly,
              ),
            )
            .score,
        greaterThan(kCreditOptInScoreThreshold),
      );
    });
  });

  group('MlScoreEngine', () {
    test('falls back to rules when no model', () {
      final ml = MlScoreEngine();
      expect(ml.score(_diag()).score, 20);
    });
  });
}
