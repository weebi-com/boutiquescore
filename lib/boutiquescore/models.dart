// Domain models mirroring evaluation.proto (client-side; no generated stubs).

class MoneyAmount {
  const MoneyAmount({
    required this.amountMinor,
    required this.currency,
  });

  final int amountMinor;
  final String currency;

  Map<String, Object> toJson() => {
        'amountMinor': amountMinor,
        'currency': currency,
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

/// OHADA legal form — wire acronyms match evaluation_service.LegalForm.
enum LegalForm {
  unspecified,
  ei,
  entreprenant,
  sarl,
  sa,
  sas,
  gie,
  other;

  /// Proto / JSON enum name (EI, SARL, …).
  String get protoName => switch (this) {
        LegalForm.unspecified => 'LEGAL_FORM_UNSPECIFIED',
        LegalForm.ei => 'EI',
        LegalForm.entreprenant => 'ENTREPRENANT',
        LegalForm.sarl => 'SARL',
        LegalForm.sa => 'SA',
        LegalForm.sas => 'SAS',
        LegalForm.gie => 'GIE',
        LegalForm.other => 'OTHER',
      };

  /// Full label for the web UI (not persisted).
  String get labelFr => switch (this) {
        LegalForm.unspecified => '',
        LegalForm.ei => 'Entreprise individuelle',
        LegalForm.entreprenant => 'Entreprenant',
        LegalForm.sarl => 'Société à responsabilité limitée',
        LegalForm.sa => 'Société anonyme',
        LegalForm.sas => 'Société par actions simplifiée',
        LegalForm.gie => "Groupement d'intérêt économique",
        LegalForm.other => 'Autre',
      };

  static LegalForm fromProto(String? raw) {
    switch (raw) {
      case 'EI':
        return LegalForm.ei;
      case 'ENTREPRENANT':
        return LegalForm.entreprenant;
      case 'SARL':
        return LegalForm.sarl;
      case 'SA':
        return LegalForm.sa;
      case 'SAS':
        return LegalForm.sas;
      case 'GIE':
        return LegalForm.gie;
      case 'OTHER':
        return LegalForm.other;
      default:
        return LegalForm.unspecified;
    }
  }

  /// Choices shown in the funnel (excludes unspecified).
  static const selectable = <LegalForm>[
    LegalForm.ei,
    LegalForm.entreprenant,
    LegalForm.sarl,
    LegalForm.sa,
    LegalForm.sas,
    LegalForm.gie,
    LegalForm.other,
  ];
}

class RegistrationDetails {
  const RegistrationDetails({
    this.commercialRegisterNumber = '',
    this.legalForm = LegalForm.unspecified,
  });

  final String commercialRegisterNumber;
  final LegalForm legalForm;

  Map<String, Object> toJson() => {
        if (commercialRegisterNumber.isNotEmpty)
          'commercialRegisterNumber': commercialRegisterNumber,
        if (legalForm != LegalForm.unspecified) 'legalForm': legalForm.protoName,
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
    required this.wantsLoan,
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
  final bool wantsLoan;
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
