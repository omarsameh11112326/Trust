// ignore_for_file: avoid_print, prefer_const_constructors, file_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';
import 'package:lottie/lottie.dart';
import 'package:yousef_nour/generated/l10n.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    super.key,
    required this.imageProduct,
    required this.nameProduct,
  });

  final String imageProduct;
  final String nameProduct;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  Future<void> checkIfFavorite() async {
    CollectionReference favProduct = FirebaseFirestore.instance.collection('favProduct');

    QuerySnapshot querySnapshot = await favProduct.where('nameProduct', isEqualTo: widget.nameProduct).get();
    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        isFavorite = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference products = FirebaseFirestore.instance.collection('products');

    return FutureBuilder<QuerySnapshot>(
      future: products.where('nameProduct', isEqualTo: widget.nameProduct).get(),
      builder: (context, snapshot) {

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Error fetching product data.')),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Scaffold(
            body: Center(
              child: Lottie.network(
                "https://lottie.host/5284eb0c-9d6f-442f-82d8-cc9fe85ba642/DQp1XQwrwH.json",
                height: MediaQuery.of(context).size.height * 0.30,
              ),
            ),
          );
        }

        final productData = snapshot.data!.docs.first.data() as Map<String, dynamic>;

        final String description = productData['descriptionProduct'] ?? 'No description available';
        final String price = productData['priceProduct'] ?? 'No price available';

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              S.of(context).ProductDetails,
              style: const TextStyle(
                color: Colors.teal,
              ),
            ),
            iconTheme: const IconThemeData(
              color: Colors.teal,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FillImageCard(
                    width: double.infinity,
                    heightImage: 200,
                    imageProvider: NetworkImage(widget.imageProduct),
                    title: Text(
                      widget.nameProduct,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    description: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${S.of(context).price}: $price EG',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () async {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                              if (isFavorite) {
                                await addFavouriteProduct(
                                  nameProduct: widget.nameProduct,
                                  imageProduct: widget.imageProduct,
                                  price: price,
                                );
                              } else {
                                await deleteFavouriteProduct(nameProduct: widget.nameProduct);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> addFavouriteProduct({String? nameProduct, String? imageProduct, String? price}) async {
    try {
    final User? currentUser = FirebaseAuth.instance.currentUser;
     String? userid= currentUser?.uid;
      CollectionReference favProduct = FirebaseFirestore.instance.collection('favProduct');
      await favProduct.add({
        "nameProduct": nameProduct,
        "imageProduct": imageProduct,
        "priceProduct": price,
        "userId":userid
      });
    } on Exception catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add favorite. Please try again later.')),
      );
    }
  }

  Future<void> deleteFavouriteProduct({required String nameProduct}) async {
    try {
      CollectionReference favProduct = FirebaseFirestore.instance.collection('favProduct');

      QuerySnapshot querySnapshot = await favProduct.where('nameProduct', isEqualTo: nameProduct).get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      print('Product deleted successfully');
    } on Exception catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete product. Please try again later.')),
      );
    }
  }
}
