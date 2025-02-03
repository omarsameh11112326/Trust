// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_card/image_card.dart';
import 'package:yousef_nour/components/button.dart';
import 'package:yousef_nour/components/offerDetails.dart'; // Make sure to add this dependency

class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  _OffersPage createState() => _OffersPage();
}

class _OffersPage extends State<OffersPage> {
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('offers').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading products'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No products found'));
                }

                final offers = snapshot.data!.docs;

                return Column(
                  children: offers.map((offers) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: FillImageCard(
                        width: double.infinity,
                        heightImage: 300, // Adjust to your design
                        imageProvider: NetworkImage(offers['imageOffer']),
                        title: Text(
                          offers['nameOffer'],
                          style: const TextStyle(color:  Color(0xFF2F019E), fontSize: 20 ,fontWeight: FontWeight.bold),
                        ),
                        description: Text(
                          offers['descriptionOffer'] ?? 'No description',
                          style: const TextStyle(color: Colors.black),
                        ),
                        footer: Center(
                          child: CustomButton(ButtonText: "View Details", OnPressed: (){
                            Navigator.of(context).push(
          MaterialPageRoute(builder: (context) =>  OfferDetails(imageProduct: offers['imageOffer'],nameProduct: offers['nameOffer'] ,)),
        );
                          }
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
