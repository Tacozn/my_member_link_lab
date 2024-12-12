import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_member_link_lab/myconfig.dart';
import 'package:my_member_link_lab/models/product.dart';
import 'package:my_member_link_lab/models/cart.dart';
import 'package:my_member_link_lab/views/cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> productList = [];
  List<Product> filteredProductList = [];
  final TextEditingController _searchController = TextEditingController();
  int numOfPages = 1;
  int currentPage = 1;
  int itemsPerPage = 4; 
  int numberOfResults = 0;
  bool _isLoading = true;
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadProductData();
  }

  void loadProductData({int page = 1}) {
    setState(() {
      _isLoading = true;
    });
    http
        .get(Uri.parse(
            "${MyConfig.servername}/memberlink/api/load_products.php?pageno=$page"))
        .then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['products'];
          productList.clear();
          for (var item in result) {
            Product product = Product.fromJson(item);
            productList.add(product);
          }
          filteredProductList = List.from(productList);
          numOfPages = int.parse(data['numofpage'].toString());
          numberOfResults = int.parse(data['numberofresult'].toString());
        }
        setState(() {
          _isLoading = false;
          currentPage = page; // Update current page
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load products'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void _searchProducts(String query) {
    setState(() {
      filteredProductList = productList
          .where((product) =>
              product.productName
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              product.productDescription
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  void _navigateToCartScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(cartItems: cartItems),
      ),
    );
  }
  void _showProductDetailsDialog(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  child: CachedNetworkImage(
                    imageUrl:
                        "${MyConfig.servername}/memberlink/product_images/${product.productImage}?t=${DateTime.now().millisecondsSinceEpoch}",
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName ?? 'Product Name',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        product.productDescription ??
                            'No description available',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price: \RM${product.productPrice?.toStringAsFixed(2) ?? '0.00'}',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.green),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Quantity Available: ${product.productQuantity ?? 0}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            cartItems
                                .add(CartItem(product: product, quantity: 1));
                          });
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Added ${product.productName} to cart'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership Products',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: _navigateToCartScreen,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search, color: Colors.lightBlue),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _searchProducts,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: filteredProductList.isEmpty
                      ? const Center(
                          child: Text(
                            'No Products Available',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(10),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: filteredProductList.length,
                          itemBuilder: (context, index) {
                            final product = filteredProductList[index];
                            return GestureDetector(
                              onTap: () => _showProductDetailsDialog(product),
                              child: Card(
                                color: Colors.lightBlue[50],
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          const BorderRadius.vertical(
                                              top: Radius.circular(15)),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${MyConfig.servername}/memberlink/product_images/${product.productImage}?t=${DateTime.now().millisecondsSinceEpoch}",
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                        errorWidget:
                                            (context, url, error) =>
                                                const Icon(Icons.error),
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.productName ??
                                                'Product Name',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            '\RM${product.productPrice?.toStringAsFixed(2) ?? '0.00'}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.green),
                                          ),
                                          const SizedBox(height: 5),
                                          /*Text(
                                            'Qty : ${product.productQuantity ?? 0}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ), */
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                if (numOfPages > 1)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: currentPage > 1
                              ? () => loadProductData(page: currentPage - 1)
                              : null,
                          child: const Text('Previous'),
                        ),
                        Text('Page $currentPage of $numOfPages'),
                        ElevatedButton(
                          onPressed: currentPage < numOfPages
                              ? () => loadProductData(page: currentPage + 1)
                              : null,
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}