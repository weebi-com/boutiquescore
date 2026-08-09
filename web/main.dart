import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;
import 'package:wasm/boutiquescore.dart';

/// JS-facing BoutiqueScore API for the HTML tunnel.
class BoutiqueScoreApi {
  BoutiqueScoreApi({ScoreEngine? engine})
      : _engine = engine ?? const RuleBasedScoreEngine();

  final ScoreEngine _engine;

  @JSExport('currencyForCountry')
  String currencyForCountryJs(String countryIso2) =>
      requireCurrencyForCountry(countryIso2);

  @JSExport('dialCode')
  int dialCodeJs(String countryIso2) =>
      DialCodes.forCountry(countryIso2) ?? 0;

  @JSExport('creditOptInThreshold')
  int creditOptInThreshold() => kCreditOptInScoreThreshold;

  @JSExport('activitiesJson')
  String activitiesJson() {
    return jsonEncode([
      for (final a in ActivityCatalog.all)
        {
          'key': a.compositeKey,
          'isicCode': a.isicCode,
          'subCode': a.subCode,
          'label': a.displayLabel,
        },
    ]);
  }

  @JSExport('legalFormsJson')
  String legalFormsJson() => jsonEncode([
        for (final f in LegalForm.selectable)
          {'code': f.protoName, 'label': f.labelFr},
      ]);

  /// Phase A: score from Q1–Q5 only (no phone / PII required).
  @JSExport('scoreOnly')
  String scoreOnly(String inputJson) {
    final map = jsonDecode(inputJson) as Map<String, dynamic>;
    final diagnostic = _diagnosticFromMap(map, requireActivity: false);
    final score = _engine.score(diagnostic);
    return jsonEncode({
      ...score.toJson(),
      'eligibleForCreditOptIn': score.score > kCreditOptInScoreThreshold,
    });
  }

  /// Phase B: full lead payload (phone required).
  @JSExport('evaluate')
  String evaluate(String inputJson) {
    final map = jsonDecode(inputJson) as Map<String, dynamic>;
    final countryIso2 = (map['countryIso2'] as String? ?? 'CM').toUpperCase();
    final dial = DialCodes.forCountry(countryIso2) ?? 237;
    final phoneNumber =
        (map['phoneNumber'] as String? ?? '').replaceAll(RegExp(r'\D'), '');
    final city = map['city'] as String? ?? '';
    final campaignId = map['campaignId'] as String? ?? '';
    final mfiPartnerId = map['mfiPartnerId'] as String? ?? '';
    final honeypot = map['honeypot'] as String? ?? '';

    if (honeypot.isNotEmpty) {
      return jsonEncode({'error': 'rejected'});
    }
    if (phoneNumber.isEmpty) {
      return jsonEncode({'error': 'missing_contact'});
    }

    final diagnostic = _diagnosticFromMap(map, requireActivity: true);
    final contact = PhoneContact(
      phone: PhoneNumber(countryCode: dial, number: phoneNumber),
      country: CountryInfo(
        code2Letters: countryIso2,
        namel10n: map['countryName'] as String? ?? '',
      ),
      city: city.trim(),
      merchantName: map['merchantName'] as String? ?? '',
    );

    final input = EvaluationInput(
      contact: contact,
      diagnostic: diagnostic,
      campaignId: campaignId,
      mfiPartnerId: mfiPartnerId,
    );

    final score = _engine.score(diagnostic);
    final payload = buildSubmitPayload(input);

    return jsonEncode({
      ...score.toJson(),
      'payload': payload,
    });
  }

  BusinessDiagnostic _diagnosticFromMap(
    Map<String, dynamic> map, {
    required bool requireActivity,
  }) {
    final countryIso2 = (map['countryIso2'] as String? ?? 'CM').toUpperCase();
    final activityKey = map['activityKey'] as String? ?? '';
    final activity = activityKey.isEmpty
        ? null
        : ActivityCatalog.byCompositeKey(activityKey);
    final wantsLoan = map['wantsLoan'] == true;
    final isRegistered = map['isRegistered'] == true;
    final rccm = map['commercialRegisterNumber'] as String? ?? '';
    final legalForm = LegalForm.fromProto(map['legalForm'] as String?);
    final loanRaw = map['requestedLoanAmount'] as String? ?? '';

    final isic = activity?.isicCode ??
        (activityKey.contains(':')
            ? activityKey.split(':').first
            : activityKey);
    final sub = activity?.subCode ??
        (activityKey.contains(':')
            ? activityKey.substring(activityKey.indexOf(':') + 1)
            : '');

    return BusinessDiagnostic(
      activityIsicCode: requireActivity && isic.isEmpty ? '4719' : isic,
      activitySubCode: sub,
      isRegistered: isRegistered,
      shopTenure: _parseTenure(map['shopTenure'] as String?),
      supplierCredit: _parseSupplier(map['supplierCredit'] as String?),
      cashSeparation: _parseCash(map['cashSeparation'] as String?),
      customerCreditTracking:
          _parseCustomerCredit(map['customerCreditTracking'] as String?),
      restockFrequency: _parseRestock(map['restockFrequency'] as String?),
      wantsLoan: wantsLoan,
      requestedLoanAmount: wantsLoan
          ? parseLoanAmount(countryIso2: countryIso2, rawAmount: loanRaw)
          : null,
      registration: isRegistered
          ? RegistrationDetails(
              commercialRegisterNumber: rccm,
              legalForm: legalForm,
            )
          : null,
    );
  }

  ShopTenure _parseTenure(String? raw) {
    switch (raw) {
      case 'UNDER_ONE_YEAR':
        return ShopTenure.underOneYear;
      case 'ONE_TO_THREE_YEARS':
        return ShopTenure.oneToThreeYears;
      case 'OVER_THREE_YEARS':
        return ShopTenure.overThreeYears;
      default:
        return ShopTenure.unspecified;
    }
  }

  SupplierCredit _parseSupplier(String? raw) {
    switch (raw) {
      case 'CASH_ONLY':
        return SupplierCredit.cashOnly;
      case 'SHORT_TERM':
        return SupplierCredit.shortTerm;
      case 'REGULAR_CONSIGNMENT':
        return SupplierCredit.regularConsignment;
      default:
        return SupplierCredit.unspecified;
    }
  }

  CashSeparation _parseCash(String? raw) {
    switch (raw) {
      case 'MIXED_HOUSEHOLD':
        return CashSeparation.mixedHousehold;
      case 'FIXED_SALARY_OR_LOGGED':
        return CashSeparation.fixedSalaryOrLogged;
      case 'FULLY_SEPARATED':
        return CashSeparation.fullySeparated;
      default:
        return CashSeparation.unspecified;
    }
  }

  CustomerCreditTracking _parseCustomerCredit(String? raw) {
    switch (raw) {
      case 'MEMORY_ONLY':
        return CustomerCreditTracking.memoryOnly;
      case 'PAPER_NOTEBOOK':
        return CustomerCreditTracking.paperNotebook;
      case 'DEDICATED_OR_APP':
        return CustomerCreditTracking.dedicatedOrApp;
      default:
        return CustomerCreditTracking.unspecified;
    }
  }

  RestockFrequency _parseRestock(String? raw) {
    switch (raw) {
      case 'LESS_THAN_WEEKLY':
        return RestockFrequency.lessThanWeekly;
      case 'ONE_TO_TWO_PER_WEEK':
        return RestockFrequency.oneToTwoPerWeek;
      case 'MORE_THAN_TWICE_WEEKLY':
        return RestockFrequency.moreThanTwiceWeekly;
      default:
        return RestockFrequency.unspecified;
    }
  }
}

void main() {
  web.window.setProperty(
    'boutiquescore'.toJS,
    createJSInteropWrapper(BoutiqueScoreApi()),
  );
}
