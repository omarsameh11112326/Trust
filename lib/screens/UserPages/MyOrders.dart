// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String userId = currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(color: Color(0xFF2F019E)),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orderDetailsSub')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final orderData = order.data() as Map<String, dynamic>;

              // Assuming 'items' contains a list of products in the order
              var items = orderData['cartItems'] ?? [];
              double totalPrice = 0.0;
              int totalQuantity = 0;

              // Calculate total price and quantity
              for (var item in items) {
                double price = item['priceProduct'] ?? 0.0;
                int quantity = item['quantity'] ?? 0;
                totalPrice += price * quantity;
                totalQuantity += quantity;
              }

              // Formatting the order date (assuming 'timestamp' or 'createdAt' field is available)
              DateTime orderDate = orderData['createdAt']?.toDate() ?? DateTime.now();
              String formattedDate = DateFormat('yyyy-MM-dd – HH:mm').format(orderDate);

              return Card(
                elevation: 5,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text('Address: ${orderData['Address'] ?? 'N/A'}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Notes: ${orderData['Notes'] ?? 'N/A'}'),
                      Text('Government: ${orderData['Government'] ?? 'N/A'}'),
                      Text('Status: ${orderData['status'] ?? 'Pending'}'),
                      Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'),
                      Text('Total Quantity: $totalQuantity'),
                      Text('Order Date: $formattedDate'),
                      const SizedBox(height: 10),

                      if (items.isNotEmpty)
                        ...items.map((item) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Product: ${item['nameProduct'] ?? 'Unknown'}'),
                              Text('Qty: ${item['quantity'] ?? 0}'),
                              Text(
                                  'Price: \$${(item['priceProduct'] ?? 0.0) * (item['quantity'] ?? 1)}'),
                              const SizedBox(height: 5),
                            ],
                          );
                        }).toList(),
                      if (items.isEmpty)
                        const Text('No items in this order'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
