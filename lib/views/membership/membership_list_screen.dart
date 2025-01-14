import 'package:flutter/material.dart';
import '../../models/membership.dart';
import 'membership_details_screen.dart';


class MembershipListScreen extends StatefulWidget {
  const MembershipListScreen({super.key});

  @override
  State<MembershipListScreen> createState() => _MembershipListScreenState();
}

class _MembershipListScreenState extends State<MembershipListScreen> {
  List<Membership> memberships = [
    Membership(
      name: 'Basic Membership',
      description: 'Perfect for beginners',
      price: 29.99,
      benefits: '- Access to basic facilities\n- Standard support\n- Monthly newsletter',
    ),
    Membership(
      name: 'Premium Membership',
      description: 'For dedicated members',
      price: 59.99,
      benefits: '- Access to all facilities\n- 24/7 support\n- Weekly newsletter\n- Personal trainer',
    ),
    Membership(
      name: 'VIP Membership',
      description: 'Ultimate experience',
      price: 99.99,
      benefits: '- All Premium features\n- Priority access\n- Exclusive events\n- Spa services',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership Plans', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: memberships.length,
          itemBuilder: (context, index) {
            final membership = memberships[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MembershipDetailsScreen(membership),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        membership.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'RM ${membership.price.toStringAsFixed(2)}/month',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...membership.benefits.split('\n').map((benefit) => 
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(child: Text(benefit.replaceAll('-', '').trim())),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MembershipDetailsScreen(membership),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('View More Details'),
                      ),
                    ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}