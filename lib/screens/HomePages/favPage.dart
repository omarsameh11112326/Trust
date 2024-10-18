// ignore_for_file: prefer_const_constructors, avoid_print, file_names


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

// ignore: camel_case_types
class favPage extends StatelessWidget {
  const favPage({super.key});

  @override
  Widget build(BuildContext context) {
       User? currentUser = FirebaseAuth.instance.currentUser;
     String? userId= currentUser?.uid;
    return Scaffold(
    
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('favProduct').where("userId",isEqualTo: userId).snapshots(),
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
              child: Text('No favourite products found'),
            );
          }

          return ListView.builder(
            itemCount: data.docs.length,
            itemBuilder: (context, index) {
              var product = data.docs[index];
              return ListTile(
                leading: product['imageProduct'] != null
                    ? Image.network(product['imageProduct'])
                    : const Icon(Icons.image),
                title: Text(product['nameProduct'] ?? 'Unnamed Product'),
                subtitle: Text('Price: ${product['priceProduct'] ?? 'N/A'}'),
                trailing: IconButton(icon: Icon(Icons.clear),onPressed: () => deleteFavouriteProduct(nameProduct: product['nameProduct']),),
              );
            },
          );
        },
      ),
    );
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
    
  }
}
}
