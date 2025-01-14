class Membership {
  final String name;
  final String description;
  final double price;
  final String benefits;
  String paymentStatus;

  Membership({
    required this.name,
    required this.description,
    required this.price,
    required this.benefits,
    this.paymentStatus = 'Pending',
  });

  
  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.parse(json['price']?.toString() ?? '0.0'),
      benefits: json['benefits'] ?? '',
      paymentStatus: json['payment_status'] ?? 'Pending',
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'benefits': benefits,
      'payment_status': paymentStatus,
    };
  }

  void updatePaymentStatus(String status) {
    paymentStatus = status;
  }
}