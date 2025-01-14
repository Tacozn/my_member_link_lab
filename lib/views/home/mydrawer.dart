import 'package:flutter/material.dart';
import 'package:my_member_link_lab/views/news/news_screen.dart';
import 'package:my_member_link_lab/views/products/product_list_screen.dart';
import 'package:my_member_link_lab/views/home/main_screen.dart';
import 'package:my_member_link_lab/views/membership/membership_list_screen.dart';
import 'package:my_member_link_lab/views/membership/purchase_summary_screen.dart';


class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blue[800],
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MyMemberLink',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                Image.asset(
                  'assets/images/metlo.png',
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text("Home", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("News", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewsScreen(),
                ),
              );
            },
          ),
          ListTile(
            title:
                const Text("Products", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductListScreen(),
                ),
              );
            },
          ),
          ListTile(
            title:
                const Text("Membership", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MembershipListScreen(),
                ),
              );
            },
          ),
          ListTile(
  leading: const Icon(Icons.history, color: Colors.white),
  title: const Text(
    "Purchase History",
    style: TextStyle(color: Colors.white),
  ),
  onTap: () {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PurchaseSummaryScreen(),
      ),
    );
  },
),
        ],
      ),
    );
  }
}
