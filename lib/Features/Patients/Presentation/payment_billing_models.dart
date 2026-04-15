enum PaymentTransactionStatus { completed, pending }

/// A single payment transaction displayed in the UI.
class PaymentTransactionModel {
  final String? id;
  final String? personName;
  final String? serviceType;
  final double? amount;
  final DateTime? date;
  final PaymentTransactionStatus? status;

  const PaymentTransactionModel({
    this.id,
    this.personName,
    this.serviceType,
    this.amount,
    this.date,
    this.status,
  });
}

/// Summary figures shown in the top cards of the Payments & Billing screen.
class PaymentSummaryModel {
  final double? totalSpent;
  final double? pendingAmount;

  const PaymentSummaryModel({
    this.totalSpent,
    this.pendingAmount,
  });
}

/// A saved payment card.
class PaymentCardModel {
  final String? cardBrand;
  final String? lastFourDigits;
  final String? expiryDate;
  final bool isPrimary;

  const PaymentCardModel({
    this.cardBrand,
    this.lastFourDigits,
    this.expiryDate,
    this.isPrimary = false,
  });
}
