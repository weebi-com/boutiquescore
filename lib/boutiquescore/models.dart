// Domain models mirroring evaluation.proto (client-side; no generated stubs).

class MoneyAmount {
  const MoneyAmount({
    required this.amountMinor,
    required this.currencyCode,
  });

  final int amountMinor;
  final String currencyCode;

  Map<String, Object> toJson() => {
        'amountMinor': amountMinor,
        'currencyCode': currencyCode,
      };
}

class PhoneNumber {
  const PhoneNumber({
    required this.countryCode,
    required this.number,
  });

  final int countryCode;
  final String number;

  Map<String, Object> toJson() => {
        'countryCode': countryCode,
        'number': number,
      };
}

class CountryInfo {
  const CountryInfo({
    required this.code2Letters,
    this.namel10n = '',
  });

  final String code2Letters;
  final String namel10n;

  Map<String, Object> toJson() => {
        'code2Letters': code2Letters,
        'namel10n': namel10n,
      };
}

class PhoneContact {
  const PhoneContact({
    required this.phone,
    required this.country,
    required this.city,
    this.merchantName = '',
  });

  final PhoneNumber phone;
  final CountryInfo country;
  final String city;
  final String merchantName;

  Map<String, Object> toJson() => {
        'phone': phone.toJson(),
        'country': country.toJson(),
        'city': city,
        if (merchantName.isNotEmpty) 'merchantName': merchantName,
      };
}

/// Q1 — max 20
enum ShopTenure {
  unspecified,
  underOneYear,
  oneToThreeYears,
  overThreeYears,
}

/// Q2 — max 25
enum SupplierCredit {
  unspecified,
  cashOnly,
  shortTerm,
  regularConsignment,
}

/// Q3 — max 25
enum CashSeparation {
  unspecified,
  mixedHousehold,
  fixedSalaryOrLogged,
  fullySeparated,
}

/// Q4 — max 15
enum CustomerCreditTracking {
  unspecified,
  memoryOnly,
  paperNotebook,
  dedicatedOrApp,
}

/// Q5 — max 15
enum RestockFrequency {
  unspecified,
  lessThanWeekly,
  oneToTwoPerWeek,
  moreThanTwiceWeekly,
}

/// Documented legal form codes (OHADA-oriented strings, not a proto enum).
abstract final class LegalFormCode {
  static const ei = 'ENTREPRISE_INDIVIDUELLE';
  static const entreprenant = 'ENTREPRENANT';
  static const sarl = 'SOCIETE_A_RESPONSABILITE_LIMITEE';
  static const sa = 'SOCIETE_ANONYME';
  static const sas = 'SOCIETE_PAR_ACTIONS_SIMPLE';
  static const gie = 'GROUPEMENT_INDIVIDUEL_D_ENTREPRISE';
  static const other = 'OTHER';

  static const all = <String>[
    ei,
    entreprenant,
    sarl,
    sa,
    sas,
    gie,
    other,
  ];
}

class RegistrationDetails {
  const RegistrationDetails({
    this.commercialRegisterNumber = '',
    this.legalFormCode = '',
  });

  final String commercialRegisterNumber;
  final String legalFormCode;

  Map<String, Object> toJson() => {
        if (commercialRegisterNumber.isNotEmpty)
          'commercialRegisterNumber': commercialRegisterNumber,
        if (legalFormCode.isNotEmpty) 'legalFormCode': legalFormCode,
      };
}

class BusinessDiagnostic {
  const BusinessDiagnostic({
    required this.activityIsicCode,
    this.activitySubCode = '',
    required this.isRegistered,
    required this.shopTenure,
    required this.supplierCredit,
    required this.cashSeparation,
    required this.customerCreditTracking,
    required this.restockFrequency,
    required this.wantsMfiLoan,
    this.requestedLoanAmount,
    this.registration,
    this.clientExtras = const {},
  });

  final String activityIsicCode;
  final String activitySubCode;
  final bool isRegistered;
  final ShopTenure shopTenure;
  final SupplierCredit supplierCredit;
  final CashSeparation cashSeparation;
  final CustomerCreditTracking customerCreditTracking;
  final RestockFrequency restockFrequency;
  final bool wantsMfiLoan;
  final MoneyAmount? requestedLoanAmount;
  final RegistrationDetails? registration;
  final Map<String, String> clientExtras;
}

/// Reserved for later product logic — not driven by this gather iteration.
enum ActionRecommendation {
  unspecified,
  directMfiContact,
  requireWeebiProof,
}

class ScoreResult {
  const ScoreResult({
    required this.score,
    required this.recommendation,
    required this.redirectUrl,
    required this.message,
  });

  final int score;
  final ActionRecommendation recommendation;
  final String redirectUrl;
  final String message;

  Map<String, Object> toJson() => {
        'score': score,
        'recommendation': recommendation.name,
        'redirectUrl': redirectUrl,
        'message': message,
      };
}

class EvaluationInput {
  const EvaluationInput({
    required this.contact,
    required this.diagnostic,
    this.campaignId = '',
    this.mfiPartnerId = '',
  });

  final PhoneContact contact;
  final BusinessDiagnostic diagnostic;
  final String campaignId;
  final String mfiPartnerId;
}
