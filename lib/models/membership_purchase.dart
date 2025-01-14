class MembershipPurchase {
  final String membershipName;
  final double amount;
  final DateTime purchaseDate;
  final String paymentStatus;
  final String? transactionId;

  MembershipPurchase({
    required this.membershipName,
    required this.amount,
    required this.purchaseDate,
    required this.paymentStatus,
    this.transactionId,
  });
}