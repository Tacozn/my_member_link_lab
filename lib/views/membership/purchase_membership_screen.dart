import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../myconfig.dart';
import 'package:flutter/material.dart';
import 'package:my_member_link_lab/models/membership.dart';
import 'package:my_member_link_lab/views/membership/payment_service.dart';
import 'package:my_member_link_lab/views/membership/purchase_summary_screen.dart';
import 'package:flutter/foundation.dart';


class PurchaseMembershipScreen extends StatefulWidget {
  final Membership membership;

  const PurchaseMembershipScreen({Key? key, required this.membership})

      : super(key: key);

  @override
  _PurchaseMembershipScreenState createState() =>
      _PurchaseMembershipScreenState();
}

class _PurchaseMembershipScreenState extends State<PurchaseMembershipScreen> {
  String _paymentStatus = 'Pending';
  final _formKey = GlobalKey<FormState>();
  final _paymentService = PaymentService();
  bool isPaymentSuccessful = false;
  bool isProcessing = false;
  String? cardNumber;
  String? expiryDate;
  String? cvv;
  String? transactionId;

  Future<void> addPurchase() async {
  http.post(
    Uri.parse("${MyConfig.servername}/memberlink/api/store_payment.php"),
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      "membership_name": widget.membership.name,
      "amount": widget.membership.price.toString(),
      "transaction_id": transactionId ?? "",  // Make sure transactionId is not null
      "payment_status": "completed",  // Changed from "Paid" to match your test data
      "purchase_date": DateTime.now().toIso8601String(),
    },
  ).then((response) {
    print("Response status: ${response.statusCode}");  // Debug print
    print("Response body: ${response.body}");  // Debug print
    
    
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Purchase successfully recorded"),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to record purchase: ${data['error'] ?? 'Unknown error'}"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }).catchError((error) {
    print("Error: $error");  // Debug print
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Error: $error"),
      backgroundColor: Colors.red,
    ));
  });
}
 @override
  void initState() {
    super.initState();
    widget.membership.updatePaymentStatus('Pending');
  }
  Future<void> processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() {
      isProcessing = true;
       widget.membership.updatePaymentStatus('Processing');
    });

    try {
      final response = await _paymentService.processPayment(
        cardNumber: cardNumber!,
        expiryDate: expiryDate!,
        cvv: cvv!,
        amount: widget.membership.price,
      );

      if (response.success) {
        transactionId = response.transactionId;
        // Update payment status
        setState(() {
          _paymentStatus = 'Paid';
          isProcessing = false;
          isPaymentSuccessful = true;
        });
        widget.membership.updatePaymentStatus('Paid');
        await addPurchase();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment successful! Check your purchase history.'),
              backgroundColor: Colors.green,
            ),
          );

          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PurchaseSummaryScreen(),
              ),
            );
          });
        }
      } else {
      if (mounted) {
        setState(() => isProcessing = false);
        widget.membership.updatePaymentStatus('Failed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: ${response.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  } catch (e) {
    if (mounted) {
      setState(() => isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing payment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase ${widget.membership.name}',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Summary Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Summary',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Divider(height: 32),
                        Text('Membership: ${widget.membership.name}'),
                        const SizedBox(height: 8),
                        Text('Description: ${widget.membership.description}'),
                        const SizedBox(height: 8),
                        Text(
                          'Price: RM ${widget.membership.price.toStringAsFixed(2)}/month',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text(
                              'Payment Status: ',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: widget.membership.paymentStatus == 'Paid'
                                    ? Colors.green[100]
                                    : widget.membership.paymentStatus ==
                                            'Failed'
                                        ? Colors.red[100]
                                        : Colors.orange[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.membership.paymentStatus,
                                style: TextStyle(
                                  color:
                                      widget.membership.paymentStatus == 'Paid'
                                          ? Colors.green[800]
                                          : widget.membership.paymentStatus ==
                                                  'Failed'
                                              ? Colors.red[800]
                                              : Colors.orange[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Payment Form
                const Text(
                  'Payment Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Add card number validation in TextFormField:
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Card Number',
                    border: OutlineInputBorder(),
                    hintText: '16 digits card number',
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter card number';
                    }
                    if (value.length != 16) {
                      return 'Card number must be 16 digits';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Card number must contain only digits';
                    }
                    return null;
                  },
                  onSaved: (value) => cardNumber = value,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Expiry Date',
                          hintText: 'MM/YY',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                            return 'Use MM/YY format';
                          }
                          final parts = value.split('/');
                          final month = int.parse(parts[0]);
                          final year = 2000 + int.parse(parts[1]);
                          if (month < 1 || month > 12) {
                            return 'Invalid month';
                          }
                          final now = DateTime.now();
                          final cardExpiry = DateTime(year, month);
                          if (cardExpiry
                              .isBefore(DateTime(now.year, now.month))) {
                            return 'Card has expired';
                          }
                          if (!cardExpiry.isAfter(DateTime(2025, 1))) {
                            return 'Date must be after 01/25';
                          }
                          return null;
                        },
                        onSaved: (value) => expiryDate = value,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'CVV',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        onSaved: (value) => cvv = value,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (isProcessing)
                  const Center(child: CircularProgressIndicator())
                else if (isPaymentSuccessful)
                  Column(
                    children: [
                      const Text(
                        'Payment Successful!',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context)
                              .popUntil((route) => route.isFirst),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Back to Home'),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              processPayment, // Change from simulatePayment(true) to processPayment
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Confirm Purchase'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
