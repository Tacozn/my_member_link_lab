class Product {
  String? productId;
  String? productName;
  String? productDescription;
  double? productPrice;
  int? productQuantity;
  String? productImage;
  

  Product({
    this.productId,
    this.productName,
    this.productDescription,
    this.productPrice,
    this.productQuantity,
    this.productImage,
    
  });

  
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id']?.toString(),
      productName: json['product_name']?.toString(),
      productDescription: json['product_description']?.toString(),
      productPrice: double.tryParse(json['product_price']?.toString() ?? '0'),
      productQuantity: int.tryParse(json['product_quantity']?.toString() ?? '0'),
      productImage: json['product_image']?.toString(),
      
    );
  }

  // Converts Product object to JSON
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_description': productDescription,
      'product_price': productPrice,
      'product_quantity': productQuantity,
      'product_image': productImage,
      
    };
  }
}
