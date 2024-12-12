import 'package:my_member_link_lab/models/product.dart';
class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
   
  });
}

