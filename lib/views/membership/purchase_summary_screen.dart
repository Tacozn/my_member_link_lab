import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../myconfig.dart';
import '../../models/membership_purchase.dart';

class PurchaseSummaryScreen extends StatefulWidget {
  const PurchaseSummaryScreen({super.key});

  @override
  State<PurchaseSummaryScreen> createState() => _PurchaseSummaryScreenState();
}

class _PurchaseSummaryScreenState extends State<PurchaseSummaryScreen> {
  List<MembershipPurchase> _purchases = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPurchases();
  }

  Future<void> loadPurchases() async {
    setState(() => _isLoading = true);
    
    http.post(
      Uri.parse("${MyConfig.servername}/memberlink/api/get_payments.php"),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          setState(() {
            _purchases = (data['data'] as List)
                .map((item) => MembershipPurchase(
                      membershipName: item['membership_name'] ?? 'Unknown',
                      amount: double.parse(item['amount']?.toString() ?? '0'),
                      purchaseDate: DateTime.parse(item['purchase_date']),
                      paymentStatus: item['payment_status'] ?? 'Unknown',
                      transactionId: item['transaction_id'],
                    ))
                .toList();
            _isLoading = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed to load purchases"),
            backgroundColor: Colors.red,
          ));
          setState(() => _isLoading = false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase History',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: loadPurchases,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _purchases.isEmpty
                ? const Center(child: Text('No purchases yet'))
                : ListView.builder(
                    itemCount: _purchases.length,
                    itemBuilder: (context, index) {
                      final purchase = _purchases[index];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(purchase.membershipName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Date: ${DateFormat('dd/MM/yyyy').format(purchase.purchaseDate)}'),
                              Text(
                                  'Amount: RM ${purchase.amount.toStringAsFixed(2)}'),
                              if (purchase.transactionId != null)
                                Text(
                                    'Transaction ID: ${purchase.transactionId}'),
                            ],
                          ),
                          trailing: _buildStatusBadge(purchase.paymentStatus),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (status.toLowerCase() == 'paid' || 
               status.toLowerCase() == 'completed') 
            ? Colors.green[100] 
            : Colors.red[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: (status.toLowerCase() == 'paid' || 
                 status.toLowerCase() == 'completed')
              ? Colors.green[800] 
              : Colors.red[800],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 
