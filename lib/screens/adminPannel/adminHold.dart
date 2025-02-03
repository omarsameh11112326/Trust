// ignore_for_file: prefer_const_constructors, file_names, use_build_context_synchronously, avoid_print


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yousef_nour/screens/AuthPages/WelcomeScreen.dart';
import 'package:yousef_nour/screens/adminPannel/AddOffers.dart';
import 'package:yousef_nour/screens/adminPannel/addProductPage.dart';
import 'package:yousef_nour/screens/adminPannel/ProductManagement.dart';
import 'package:yousef_nour/screens/adminPannel/customer%20Oreder';
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
    const ProductManagement (),
 
  ];
  int index=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
         actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
return AllOrders();
            }));
          }, icon: Icon(
            Icons.card_giftcard_sharp
          )),
          
        ],
       
        leading: IconButton(
  onPressed: (){logOut(context);},
  icon: Icon(Icons.logout),
),

          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Admin",
            style: TextStyle(
              color: Color(0xFF2F019E),
            ),
          ),
          iconTheme: const IconThemeData(
            color:  Color(0xFF2F019E),
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
            selectedItemColor: const Color(0xFF2F019E),
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
  Future<void> logOut(BuildContext context) async {
  try {
    // Sign out from Firebase
    await FirebaseAuth.instance.signOut();

    // Clear shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('isAdmin');

    // Navigate to the Welcome Screen and clear the navigation stack
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => WelcomeScreen(
          onLanguageChange: (Locale locale) {}, // Adjust to your implementation
        ),
      ),
      (route) => false, // Clears navigation stack
    );
  } catch (e) {
    print('Error during logout: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error during logout: $e')),
    );
  }
}



   

}