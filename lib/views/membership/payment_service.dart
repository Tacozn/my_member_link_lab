class PaymentService {
  Future<PaymentResponse> processPayment({
  required String cardNumber,
  required String expiryDate,
  required String cvv,
  required double amount,
}) async {
  await Future.delayed(Duration(seconds: 2));

  // Validate card number
  if (cardNumber.length != 16) {
    return PaymentResponse(
      success: false, 
      message: 'Invalid card number - must be 16 digits'
    );
  }

  // Validate expiry date format and value
  if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(expiryDate)) {
    return PaymentResponse(
      success: false, 
      message: 'Invalid expiry date format - use MM/YY'
    );
  }

  // Check if card is expired
  final parts = expiryDate.split('/');
  final month = int.parse(parts[0]);
  final year = 2000 + int.parse(parts[1]); // Convert YY to 20YY
  final now = DateTime.now();
  final cardExpiry = DateTime(year, month);

  if (cardExpiry.isBefore(DateTime(now.year, now.month))) {
    return PaymentResponse(
      success: false, 
      message: 'Card has expired'
    );
  }

  // Success only for test card and valid date
  if (cardNumber == '4111111111111111' && 
      cardExpiry.isAfter(DateTime(2025, 1))) {
    return PaymentResponse(
      success: true,
      message: 'Payment successful',
      transactionId: 'TXN${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  return PaymentResponse(
    success: false, 
    message: 'Payment declined - invalid card or expired date'
  );
}
}

class PaymentResponse {
  final bool success;
  final String message;
  final String? transactionId;

  PaymentResponse({
    required this.success,
    required this.message,
    this.transactionId,
  });
}