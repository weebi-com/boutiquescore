import 'models.dart';

String _shopTenureProto(ShopTenure v) {
  switch (v) {
    case ShopTenure.underOneYear:
      return 'UNDER_ONE_YEAR';
    case ShopTenure.oneToThreeYears:
      return 'ONE_TO_THREE_YEARS';
    case ShopTenure.overThreeYears:
      return 'OVER_THREE_YEARS';
    case ShopTenure.unspecified:
      return 'SHOP_TENURE_UNSPECIFIED';
  }
}

String _supplierCreditProto(SupplierCredit v) {
  switch (v) {
    case SupplierCredit.cashOnly:
      return 'CASH_ONLY';
    case SupplierCredit.shortTerm:
      return 'SHORT_TERM';
    case SupplierCredit.regularConsignment:
      return 'REGULAR_CONSIGNMENT';
    case SupplierCredit.unspecified:
      return 'SUPPLIER_CREDIT_UNSPECIFIED';
  }
}

String _cashSeparationProto(CashSeparation v) {
  switch (v) {
    case CashSeparation.mixedHousehold:
      return 'MIXED_HOUSEHOLD';
    case CashSeparation.fixedSalaryOrLogged:
      return 'FIXED_SALARY_OR_LOGGED';
    case CashSeparation.fullySeparated:
      return 'FULLY_SEPARATED';
    case CashSeparation.unspecified:
      return 'CASH_SEPARATION_UNSPECIFIED';
  }
}

String _customerCreditProto(CustomerCreditTracking v) {
  switch (v) {
    case CustomerCreditTracking.memoryOnly:
      return 'MEMORY_ONLY';
    case CustomerCreditTracking.paperNotebook:
      return 'PAPER_NOTEBOOK';
    case CustomerCreditTracking.dedicatedOrApp:
      return 'DEDICATED_OR_APP';
    case CustomerCreditTracking.unspecified:
      return 'CUSTOMER_CREDIT_TRACKING_UNSPECIFIED';
  }
}

String _restockProto(RestockFrequency v) {
  switch (v) {
    case RestockFrequency.lessThanWeekly:
      return 'LESS_THAN_WEEKLY';
    case RestockFrequency.oneToTwoPerWeek:
      return 'ONE_TO_TWO_PER_WEEK';
    case RestockFrequency.moreThanTwiceWeekly:
      return 'MORE_THAN_TWICE_WEEKLY';
    case RestockFrequency.unspecified:
      return 'RESTOCK_FREQUENCY_UNSPECIFIED';
  }
}

/// Builds the future SubmitEvaluationRequest JSON (store-only — no score).
Map<String, Object?> buildSubmitPayload(EvaluationInput input) {
  final d = input.diagnostic;
  final diagnostic = <String, Object?>{
    'activityIsicCode': d.activityIsicCode,
    'activitySubCode': d.activitySubCode,
    'isRegistered': d.isRegistered,
    'shopTenure': _shopTenureProto(d.shopTenure),
    'supplierCredit': _supplierCreditProto(d.supplierCredit),
    'cashSeparation': _cashSeparationProto(d.cashSeparation),
    'customerCreditTracking': _customerCreditProto(d.customerCreditTracking),
    'restockFrequency': _restockProto(d.restockFrequency),
    'wantsMfiLoan': d.wantsMfiLoan,
    if (d.requestedLoanAmount != null)
      'requestedLoanAmount': d.requestedLoanAmount!.toJson(),
    if (d.registration != null) 'registration': d.registration!.toJson(),
    if (d.clientExtras.isNotEmpty) 'clientExtras': d.clientExtras,
  };

  return {
    'contact': input.contact.toJson(),
    'diagnostic': diagnostic,
    if (input.campaignId.isNotEmpty) 'campaignId': input.campaignId,
    if (input.mfiPartnerId.isNotEmpty) 'mfiPartnerId': input.mfiPartnerId,
  };
}
