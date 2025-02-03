// ignore_for_file: prefer_const_constructors, avoid_print, file_names, camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:yousef_nour/components/button.dart';

import '../../components/orderDetailsSub.dart';

// Ignore camelCase for this file
class myRequestsPage extends StatefulWidget {
  const myRequestsPage({super.key});

  @override
  _MyRequestsPageState createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<myRequestsPage> {
  double totalPrice = 0;
  int totalQuantity = 0; 

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Cart')
            .where("userId", isEqualTo: userId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.network(
                "https://lottie.host/5284eb0c-9d6f-442f-82d8-cc9fe85ba642/DQp1XQwrwH.json",
                height: MediaQuery.of(context).size.height * 0.30,
              ),
            );
          }

          final data = snapshot.requireData;

          if (data.docs.isEmpty) {
            return const Center(
              child: Text('No products found in your cart'),
            );
          }

          // Recalculate total price and total quantity
          totalPrice = 0.0;
          totalQuantity = 0; // Reset totalQuantity
          for (var doc in data.docs) {
            double price = double.tryParse(doc['priceProduct']?.toString() ?? '0') ?? 0;
            int quantity = (doc['Quantity'] ?? 1).toInt();
            totalPrice += price * quantity;
            totalQuantity += quantity; // Add quantity to totalQuantity
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: data.docs.length,
                  itemBuilder: (context, index) {
                    var product = data.docs[index];
                    double price = double.tryParse(product['priceProduct']?.toString() ?? '0') ?? 0;
                    int quantity = (product['Quantity'] ?? 1).toInt();

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: product['imageProduct'] != null
                            ? Image.network(
                                product['imageProduct'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.image, size: 50),
                        title: Text(product['nameProduct'] ?? 'Unnamed Product'),
                        subtitle: Text(
                            'Price: EGP ${price.toStringAsFixed(0) } | Qty: $quantity'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Add Quantity Button
                            IconButton(
                              icon: Icon(Icons.add_circle_outline, color: Colors.green),
                              onPressed: () => addToCart(
                                quantity: quantity, 
                                productName: product['nameProduct'],
                              ),
                            ),
                            // Remove Quantity Button
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline, color: Colors.orange),
                              onPressed: () => removeFromCart(
                                quantity: quantity, 
                                productName: product['nameProduct'],
                              ),
                            ),
                            // Delete Product Button
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteFromCartProduct(
                                nameProduct: product['nameProduct'],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Total Price Section
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Price: ",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " $totalPrice  EGP",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ],
                ),
              ),
              // Total Quantity Section
              
              CustomButton(ButtonText: 'Buy Now', OnPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => orderDetailsSub(
                    totalPrice: totalPrice, 
                    totalQuantity: totalQuantity,
                    government: 'Cairo',
                  ),
                ));
              })
            ],
          );
        },
      ),
    );
  }

  Future<void> addToCart({required String productName, required int quantity}) async {
    try {
      CollectionReference cartCollection = FirebaseFirestore.instance.collection('Cart');
    
      // Query the product by name
      QuerySnapshot querySnapshot = await cartCollection.where('nameProduct', isEqualTo: productName).get();
    
      if (querySnapshot.docs.isNotEmpty) {
        var productDoc = querySnapshot.docs.first;
        await productDoc.reference.update({'Quantity': quantity + 1});
      }
    } catch (e) {
      print('Error adding product to cart: $e');
    }
  }

  Future<void> removeFromCart({required String productName, required int quantity}) async {
    try {
      CollectionReference cartCollection = FirebaseFirestore.instance.collection('Cart');
    
      // Query the product by name
      QuerySnapshot querySnapshot = await cartCollection.where('nameProduct', isEqualTo: productName).get();
    
      if (querySnapshot.docs.isNotEmpty) {
        var productDoc = querySnapshot.docs.first;
        if (quantity > 1) {
          await productDoc.reference.update({'Quantity': quantity - 1});
        } else {
          await productDoc.reference.delete();
        }
      }
    } catch (e) {
      print('Error removing product from cart: $e');
    }
  }

  Future<void> deleteFromCartProduct({required String nameProduct}) async {
    try {
      CollectionReference favProduct = FirebaseFirestore.instance.collection('Cart');
      QuerySnapshot querySnapshot = await favProduct.where('nameProduct', isEqualTo: nameProduct).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting product: $e');
    }
  }
}
