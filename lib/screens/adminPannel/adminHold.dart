// ignore_for_file: prefer_const_constructors, file_names, use_build_context_synchronously, avoid_print


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yousef_nour/screens/adminPannel/AddOffers.dart';
import 'package:yousef_nour/screens/adminPannel/addProductPage.dart';
import 'package:yousef_nour/screens/adminPannel/ProductManagement.dart';
import 'package:yousef_nour/screens/adminPannel/userInApp.dart';

class AdminHold extends StatefulWidget {
  const AdminHold({super.key});

  @override
  State<AdminHold> createState() => _AdminHoldState();
}

class _AdminHoldState extends State<AdminHold> {
  final List<Widget> navList = [
    const AddProductPage(),
    const AddOffers(),
    const UserManagement(),
    const ProductManagement (),
 
  ];
  int index=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        leading: IconButton(onPressed: (){
          logOut();
        }, icon: Icon(Icons.logout)),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Admin",
            style: TextStyle(
              color: Colors.teal,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.teal,
          ),
        ) ,
        body:navList[index],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: index,
            onTap: (value) {
              setState(() {
                index = value;
              });
            },
            selectedItemColor: Colors.teal,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.production_quantity_limits),
                label: "Add Product",
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_offer),
                label: "Add Offer",
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.manage_accounts),
                label:"User Management",
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.manage_history),
                label: "Product managemet",
                backgroundColor: Colors.white,
              ),
            ],
          ),
    );
  }
   Future<void> logOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); 
    await prefs.remove('isAdmin');

SystemNavigator.pop();

  } catch (e) {
    print('Error during logout: $e');
  }
}
}