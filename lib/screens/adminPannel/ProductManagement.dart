// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, library_private_types_in_public_api, file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yousef_nour/components/button.dart';

class ProductManagement extends StatelessWidget {
  const ProductManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          final products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final productData = product.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(productData['nameProduct'],),
                subtitle: Text('Price: \$${productData['priceProduct']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Navigate to edit screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProductScreen(productId: product.id),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        // Delete product
                        await FirebaseFirestore.instance.collection('products').doc(product.id).delete();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}


class EditProductScreen extends StatefulWidget {
  final String productId;

  const EditProductScreen({required this.productId, super.key});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  File? _imageFile;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final productDoc = await FirebaseFirestore.instance.collection('products').doc(widget.productId).get();
    final productData = productDoc.data() as Map<String, dynamic>;

    _nameController.text = productData['nameProduct'];
    _priceController.text = productData['priceProduct'].toString();
    setState(() {
      _imageUrl = productData['imageUrl'];
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    final storageRef = FirebaseStorage.instance.ref().child('product_images').child(widget.productId);
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask.whenComplete(() => {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _updateProduct() async {
    String? imageUrl;
    if (_imageFile != null) {
      imageUrl = await _uploadImage(_imageFile!);
    } else {
      imageUrl = _imageUrl;
    }

    await FirebaseFirestore.instance.collection('products').doc(widget.productId).update({
      'nameProduct': _nameController.text,
      'priceProduct': double.tryParse(_priceController.text) ?? 0.0,
      'imageProduct': imageUrl,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Update Products",
            style: TextStyle(
              color: Colors.teal,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.teal,
          ),
        ) ,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageFile != null
                ? Image.file(_imageFile!)
                : _imageUrl != null
                    ? Image.network(_imageUrl!)
                    : const SizedBox.shrink(),
          
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
                        SizedBox(height:10),

             Center(child: CustomButton(ButtonText: "Update Image", OnPressed: _pickImage)),
            SizedBox(height: 16),
           Center(child: CustomButton(ButtonText: "Update", OnPressed: _updateProduct))
          ],
        ),
      ),
    );
  }
}
