import 'models.dart';

/// Client-side BoutiqueScore: exact sum of Q1–Q5 points (0–100).
abstract class ScoreEngine {
  ScoreResult score(BusinessDiagnostic diagnostic);
}

/// Score above this may unlock the optional credit / contact phase (UI).
const int kCreditOptInScoreThreshold = 50;

class RuleBasedScoreEngine implements ScoreEngine {
  const RuleBasedScoreEngine({
    this.infoUrl = 'https://weebi.com',
  });

  final String infoUrl;

  @override
  ScoreResult score(BusinessDiagnostic diagnostic) {
    final points = shopTenurePoints(diagnostic.shopTenure) +
        supplierCreditPoints(diagnostic.supplierCredit) +
        cashSeparationPoints(diagnostic.cashSeparation) +
        customerCreditTrackingPoints(diagnostic.customerCreditTracking) +
        restockFrequencyPoints(diagnostic.restockFrequency);

    final score = points.clamp(0, 100);
    return ScoreResult(
      score: score,
      recommendation: ActionRecommendation.unspecified,
      redirectUrl: infoUrl,
      message: 'Votre score : $score / 100.',
    );
  }

  /// Q1 — max 20
  static int shopTenurePoints(ShopTenure v) {
    switch (v) {
      case ShopTenure.underOneYear:
        return 5;
      case ShopTenure.oneToThreeYears:
        return 12;
      case ShopTenure.overThreeYears:
        return 20;
      case ShopTenure.unspecified:
        return 0;
    }
  }

  /// Q2 — max 25
  static int supplierCreditPoints(SupplierCredit v) {
    switch (v) {
      case SupplierCredit.cashOnly:
        return 5;
      case SupplierCredit.shortTerm:
        return 15;
      case SupplierCredit.regularConsignment:
        return 25;
      case SupplierCredit.unspecified:
        return 0;
    }
  }

  /// Q3 — max 25
  static int cashSeparationPoints(CashSeparation v) {
    switch (v) {
      case CashSeparation.mixedHousehold:
        return 5;
      case CashSeparation.fixedSalaryOrLogged:
        return 18;
      case CashSeparation.fullySeparated:
        return 25;
      case CashSeparation.unspecified:
        return 0;
    }
  }

  /// Q4 — max 15
  static int customerCreditTrackingPoints(CustomerCreditTracking v) {
    switch (v) {
      case CustomerCreditTracking.memoryOnly:
        return 0;
      case CustomerCreditTracking.paperNotebook:
        return 10;
      case CustomerCreditTracking.dedicatedOrApp:
        return 15;
      case CustomerCreditTracking.unspecified:
        return 0;
    }
  }

  /// Q5 — max 15
  static int restockFrequencyPoints(RestockFrequency v) {
    switch (v) {
      case RestockFrequency.lessThanWeekly:
        return 5;
      case RestockFrequency.oneToTwoPerWeek:
        return 10;
      case RestockFrequency.moreThanTwiceWeekly:
        return 15;
      case RestockFrequency.unspecified:
        return 0;
    }
  }
}
