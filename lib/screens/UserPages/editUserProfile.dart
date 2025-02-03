// ignore_for_file: camel_case_types, prefer_const_constructors_in_immutables, file_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:yousef_nour/components/button.dart';
import 'package:yousef_nour/generated/l10n.dart';

class editUserProfile extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phone;
  final String userType;
   editUserProfile({super.key, required this.firstName, required this.lastName, required this.phone, required this.userType});
 
  @override
  State<editUserProfile> createState() => _editUserProfileState();
}
class _editUserProfileState extends State<editUserProfile> {

TextEditingController firstController=TextEditingController();
TextEditingController lastController=TextEditingController();
TextEditingController phoneController=TextEditingController();
@override
  void initState() { 
 firstController=TextEditingController(text: widget.firstName);
 lastController=TextEditingController(text: widget.lastName);
 phoneController=TextEditingController(text: widget.phone);
  WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        dropDownValue = widget.userType; 
      });
    });

      super.initState();
     
  }
  @override
  void dispose() {
   firstController=TextEditingController(text: widget.firstName);
 lastController=TextEditingController(text: widget.lastName);
 phoneController=TextEditingController(text: widget.phone);// Dispose the controller to avoid memory leaks
    super.dispose();
  }
 String? dropDownValue; 
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
           
            title: Text(
              S.of(context).MyProfile,
              style: const TextStyle(
                color:  Color(0xFF2F019E),
              ),
            ),
            iconTheme: const IconThemeData(
              color:  Color(0xFF2F019E),
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Center(
                    child: Lottie.network(
                      "https://lottie.host/c06885ce-9adb-48b0-878b-3d16cb86762a/psIo5WZrHa.json",
                      height: MediaQuery.of(context).size.height * 0.2,
              
                    ),
              
                  ),
                  TextFormField(
                    controller: firstController,
                    decoration: InputDecoration(labelText: S.of(context).firstName, labelStyle:  const TextStyle(
                    color:  Color(0xFF2F019E),
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),),                 
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: lastController,
                    decoration: InputDecoration(labelText: S.of(context).lastName, labelStyle: const TextStyle(
                    color:  Color(0xFF2F019E),
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: S.of(context).phone, labelStyle:  const TextStyle(
                    color:  Color(0xFF2F019E),
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),),
                  ),
                  Center(
                    child: DropdownButton(
                      value: dropDownValue,
                      style: const TextStyle(color: Colors.teal),
                      items:  [
                        DropdownMenuItem(
                          value:"Normal user",
                          child: Text(S.of(context).normalUser,
                         style:   const TextStyle(
                    color:  Color(0xFF2F019E),
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),),
                        ),
                        DropdownMenuItem(
                          value: "Merchant",
                          child: Text(S.of(context).merchant,
                          style:   const TextStyle(
                    color:  Color(0xFF2F019E),
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),),
                        ),
                      ],
                      onChanged: dropCallBack,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Center(child: CustomButton(ButtonText: S.of(context).upDate, OnPressed: updateUserData))
                 ],
              ),
            ),
          ),
    );

  }
Future<void> updateUserData() async {
    try {
      String firstName=firstController.text;
      String lastName=lastController.text;
      String phone=phoneController.text;
        final User? currentUser = FirebaseAuth.instance.currentUser;
    String userId = currentUser!.uid;     
       CollectionReference users = FirebaseFirestore.instance.collection('users');
      await users.doc(userId).update({
       
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phone,
        "userType": dropDownValue,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile data updated sucessfully')),
      );
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign up. Please try again later.')),
      );
    }}
     void dropCallBack(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        dropDownValue = selectedValue;
      });
    }
  }

}