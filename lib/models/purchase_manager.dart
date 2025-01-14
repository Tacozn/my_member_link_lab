import 'package:my_member_link_lab/models/membership_purchase.dart';
import 'package:flutter/foundation.dart';
import 'package:my_member_link_lab/myconfig.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseManager extends ChangeNotifier {
  static final PurchaseManager _instance = PurchaseManager._internal();
  factory PurchaseManager() => _instance;
  PurchaseManager._internal();

  List<MembershipPurchase> _purchases = [];
  List<MembershipPurchase> get purchases => _purchases;

  Future<void> addPurchase(MembershipPurchase purchase) async {
    try {
      final response = await http.post(
        Uri.parse("${MyConfig.servername}/memberlink/api/store_payment.php"),
        body: {
          "membership_name": purchase.membershipName,
          "amount": purchase.amount.toString(),
          "transaction_id": purchase.transactionId ?? "",
          "payment_status": purchase.paymentStatus,
          "purchase_date": purchase.purchaseDate.toIso8601String(),
        },
      );

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body); // Add this line
        if (jsondata['status'] == 'success') {
          _purchases.add(purchase);
          notifyListeners();
          await loadPurchases();
        }
      }
    } catch (e) {
      print("Error storing purchase: $e");
    }
  }

  Future<void> loadPurchases() async {
    try {
      final response = await http.get(
        Uri.parse("${MyConfig.servername}/memberlink/api/get_payments.php"),
      );

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          _purchases = (jsondata['data'] as List)
              .map((item) => MembershipPurchase(
                    membershipName:
                        item['membership_name'] ?? 'Unknown Membership',
                    amount: double.parse(item['amount']?.toString() ?? '0'),
                    purchaseDate: DateTime.parse(item['purchase_date'] ??
                        DateTime.now().toIso8601String()),
                    paymentStatus: item['payment_status'] ?? 'Unknown',
                    transactionId: item['transaction_id'],
                  ))
              .toList();
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error loading purchases: $e");
    }
  }
}
