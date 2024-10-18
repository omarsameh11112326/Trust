// ignore: 
// ignore_for_file: avoid_print, file_names, prefer_const_constructors, use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:yousef_nour/components/CustomTextFormField.dart';
import 'package:yousef_nour/components/button.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:yousef_nour/generated/l10n.dart';

class AddOffers extends StatefulWidget {
  const AddOffers({super.key});

  @override
  State<AddOffers> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddOffers> {
  String? nameProduct;
  String? descriptionProduct;
  String? priceProduct;
  String? imageUrl;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();
  File? _imageFile;
  final picker = ImagePicker();
  bool _isLoading = false; 

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> uploadImage() async {
    if (_imageFile == null) return;

    try {
      String fileName = basename(_imageFile!.path);

      Reference storageRef = FirebaseStorage.instance.ref().child('offers/$fileName');
      UploadTask uploadTask = storageRef.putFile(_imageFile!);

      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addProductOffer(BuildContext context) async {
      if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please pick an image for the product.')),
      );
      return; 
    }
    setState(() {
      _isLoading = true;
    });

    try {
      CollectionReference products = FirebaseFirestore.instance.collection('offers');

      await uploadImage();

      await products.add({
        "descriptionOffer": descriptionProduct,
        "nameOffer": nameProduct,
        "priceOffer": priceProduct,
        "imageOffer": imageUrl,
      });
    } on Exception catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to add product. Please try again later.')),
      );
    } finally {
      setState(() {
        _isLoading = false; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  _isLoading 
                    ? Scaffold(
                      body: Center(
                                        child: Lottie.network(
                      "https://lottie.host/5284eb0c-9d6f-442f-82d8-cc9fe85ba642/DQp1XQwrwH.json",
                      height: MediaQuery.of(context).size.height * 0.30,
                                        ),
                                      ),
                    )
           :Form(
      key: formKey,
      child: Scaffold(
        
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Lottie.network(
                    "https://lottie.host/4e2872dd-4b37-4726-a761-d3765de7e251/UyaRSp7Tf0.json",
                    height: MediaQuery.of(context).size.height * 0.30,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  label: "Offer Name",
                  icon: const Icon(Icons.disc_full),
                  inputString: (value) {
                    nameProduct = value;
                  },
                  textInputType: TextInputType.name,
                  controller: nameController,
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  label: "Offer Description",
                  icon: const Icon(Icons.border_color_outlined),
                  inputString: (value) {
                    descriptionProduct = value;
                  },
                  textInputType: TextInputType.text,
                  controller: descriptionController,
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  label: "Offer Price",
                  icon: const Icon(Icons.price_check),
                  inputString: (value) {
                    priceProduct = value;
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],  

                  textInputType: TextInputType.number,
                  controller: priceController,
                ),
                const SizedBox(height: 16),
                _imageFile == null
                    ? const Text("No image selected")
                    : Image.file(_imageFile!, height: 200),
                const SizedBox(height: 16),
                CustomButton(
                  ButtonText: "Pick Image",
                  OnPressed: () => pickImage(),
                ),
                const SizedBox(height: 16),
                CustomButton(
                        ButtonText:S.of(context).Submit,
                        OnPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (_imageFile == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please pick an image for the product.'),
                                ),
                              );
                              return;
                            }
                            await addProductOffer(context);
                            nameController.clear();
                            descriptionController.clear();
                            priceController.clear();

                            

                            setState(() {
                              _imageFile = null;
                            });
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
