// ignore: avoid_print, file_names, prefer_const_constructors

// ignore_for_file: use_build_context_synchronously, avoid_print, duplicate_ignore, file_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:yousef_nour/components/CustomTextFormField.dart';
import 'package:yousef_nour/components/button.dart';
import 'package:yousef_nour/screens/HomePages/home.dart';

// ignore: camel_case_types
class orderDetailsSub extends StatefulWidget {
  final double totalPrice;
  final int totalQuantity;
  final String? government;
  
  const orderDetailsSub({super.key, required this.totalPrice, required this.totalQuantity, this.government});

  @override
  State<orderDetailsSub> createState() => _SubmitOrderPageState();
}

class _SubmitOrderPageState extends State<orderDetailsSub> {
  String? Address;
  String? Notes;
  String? dropDownValue;

  TextEditingController AddressController = TextEditingController();
  TextEditingController NotesController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    dropDownValue = widget.government ?? "Cairo";
  }

  Future<void> SubmitOrder(BuildContext context) async {
    if (Address == null || Address!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid address')),
      );
      return;
    }

    if (Notes == null || Notes!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid notes')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      String userId = currentUser!.uid;

      // Fetch cart items for the current user
      QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('Cart')
          .where("userId", isEqualTo: userId)
          .get();

      if (cartSnapshot.docs.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your cart is empty')),
          );
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Calculate total price and quantity
      double totalPrice = 0.0;
      int totalQuantity = 0;

      List<Map<String, dynamic>> cartItems = [];

      for (var doc in cartSnapshot.docs) {
        double price = double.tryParse(doc['priceProduct']?.toString() ?? '0') ?? 0;
        int quantity = (doc['Quantity'] ?? 1).toInt();

        totalPrice += price * quantity;
        totalQuantity += quantity;

        cartItems.add({
          "nameProduct": doc['nameProduct'],
          "priceProduct": price,
          "quantity": quantity,
        });

        await doc.reference.delete();
      }

      CollectionReference orderDetailsSub =
          FirebaseFirestore.instance.collection('orderDetailsSub');

      await orderDetailsSub.add({
        "Address": Address,
        "Notes": Notes,
        "Government": dropDownValue,
        "userId": userId,
        "status": "Pending", 
        "totalPrice": totalPrice, 
        "totalQuantity": totalQuantity, 
        "cartItems": cartItems,
        "createdAt": FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your Order Submitted successfully!')),
        );
      }

      // Clear the form fields after submission
      AddressController.clear();
      NotesController.clear();
      setState(() {
        dropDownValue = "Cairo";
      });
    } catch (e) {
      print(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to Submit. Please try again later.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
            body: Center(
              child: Lottie.network(
                "https://lottie.host/5284eb0c-9d6f-442f-82d8-cc9fe85ba642/DQp1XQwrwH.json",
                height: MediaQuery.of(context).size.height * 0.30,
              ),
            ),
          )
        : Form(
            key: formKey,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Order Details',
                style: TextStyle(
                  color: Color(0xFF2F019E)
                ),
                ),
                backgroundColor: Colors.white,
              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      // Order Details Section
                      Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Price: \$${widget.totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text('Total Quantity: ${widget.totalQuantity}',
                                  style: const TextStyle(fontSize: 16)),
                              
                            ],
                          ),
                        ),
                      ),

                      // Address Input
                      CustomTextFormField(
                        label: "Address",
                        icon: const Icon(Icons.text_fields),
                        inputString: (value) {
                          Address = value;
                        },
                        textInputType: TextInputType.name,
                        controller: AddressController,
                      ),

                      // Notes Input
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        label: "Notes",
                        icon: const Icon(Icons.note_add),
                        inputString: (value) {
                          Notes = value;
                        },
                        textInputType: TextInputType.text,
                        controller: NotesController,
                      ),

                      // Dropdown for Government
                      const SizedBox(height: 5),
                      DropdownButton<String>(
                        menuWidth: MediaQuery.of(context).size.width * 0.5,
                        elevation: 10,
                        dropdownColor: const Color.fromARGB(255, 209, 203, 203),
                        alignment: Alignment.center,
                        value: dropDownValue,
                        style: const TextStyle(color: Color(0xFF2F019E)),
                        items: const [
                          DropdownMenuItem(
                            value: "Cairo",
                            child: Text("Cairo"),
                          ),
                          DropdownMenuItem(
                            value: "Alexandria",
                            child: Text("Alexandria"),
                          ),
                          DropdownMenuItem(
                            value: "Fayoum",
                            child: Text("Fayoum"),
                          ),
                        ],
                        onChanged: dropCallBack,
                      ),

                      const SizedBox(height: 50),

                      // Submit Button
                      CustomButton(
                        ButtonText: "Submit Your Order",
                        OnPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await SubmitOrder(context);
                            AddressController.clear();
                            NotesController.clear();
                          }
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const Home()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  void dropCallBack(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        dropDownValue = selectedValue;
      });
    }
  }
}
