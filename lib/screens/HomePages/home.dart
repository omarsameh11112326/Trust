// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yousef_nour/components/drawerItem.dart';
import 'package:yousef_nour/generated/l10n.dart';
import 'package:yousef_nour/screens/Search/ProductSearch.dart';
import 'package:yousef_nour/screens/AuthPages/WelcomeScreen.dart';
import 'package:yousef_nour/screens/HomePages/base.dart';
import 'package:yousef_nour/screens/HomePages/favPage.dart';
import 'package:yousef_nour/screens/HomePages/myRequestsPage.dart';
import 'package:yousef_nour/screens/HomePages/offersPage.dart';
import 'package:yousef_nour/screens/UserPages/userProfile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 3;
  final List<Widget> navList = [
    const OffersPage(),
    const myRequestsPage(),
    const favPage(),
    const Base(),
  ];

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text("No user is currently signed in"));
    }

    return WillPopScope(
      onWillPop: () async {
        // Close the app when back button is pressed
        SystemNavigator.pop();
        return false; // Prevent navigating back to the previous screen
      },
      child: FutureBuilder<DocumentSnapshot>(
        future: users.doc(currentUser.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching user data.'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No data found for this user.'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final String firstName = userData['firstName'] ?? 'No name';
          final String lastName = userData['lastName'] ?? 'No name';

          return Scaffold(
            drawer: Drawer(
              backgroundColor: Colors.white,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 250,
                        color: Colors.teal,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      return const UserProfile();
                                    }),
                                  );
                                },
                                child: const Image(
                                  image: AssetImage(
                                      "assets/nd2m6os0tmc9env4gc8jh3er0j.png"),
                                  width: 125,
                                  height: 125,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(firstName,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Text("$firstName $lastName",
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 216, 216, 216),
                                      fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            drawerItem1(
                              icon: const Icon(
                                Icons.home,
                                color: Colors.teal,
                                size: 30,
                              ),
                              label: S.of(context).home,
                              OnTap: () {},
                            ),
                            const SizedBox(height: 10),
                            const Divider(indent: 10, endIndent: 10, thickness: 2),
                            const SizedBox(height: 10),
                            drawerItem1(
                              icon: const Icon(
                                Icons.phone,
                                color: Colors.teal,
                                size: 30,
                              ),
                              label: S.of(context).contactUs,
                              OnTap: () {},
                            ),
                            const SizedBox(height: 10),
                            const Divider(indent: 10, endIndent: 10, thickness: 2),
                            const SizedBox(height: 10),
                            drawerItem1(
                              icon: const Icon(
                                Icons.person,
                                color: Colors.teal,
                                size: 30,
                              ),
                              label: S.of(context).MyProfile,
                              OnTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return const UserProfile();
                                  },
                                ));
                              },
                            ),
                            const SizedBox(height: 10),
                            const Divider(indent: 10, endIndent: 10, thickness: 2),
                            const SizedBox(height: 10),
                            drawerItem1(
                              icon: const Icon(
                                Icons.menu_book,
                                color: Colors.teal,
                                size: 30,
                              ),
                              label: S.of(context).aboutUs,
                              OnTap: () {},
                            ),
                            const SizedBox(height: 10),
                            const Divider(indent: 10, endIndent: 10, thickness: 2),
                            const SizedBox(height: 10),
                            drawerItem1(
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.teal,
                                size: 30,
                              ),
                              label: S.of(context).signOut,
                              OnTap: () {
                                logOut();
                              },
                            ),
                            const SizedBox(height: 10),
                            const Divider(indent: 10, endIndent: 10, thickness: 2),
                            const SizedBox(height: 10),
                            drawerItem1(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 30,
                              ),
                              label: S.of(context).deleteYourAccount,
                              OnTap: () {
                                deleteCurrentUser();
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return Welcome(onLanguageChange: (Locale locale) {});
                                  },
                                ));
                              },
                            ),
                            const SizedBox(height: 10),
                            const Divider(indent: 10, endIndent: 10, thickness: 2),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              actions: [
                Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Center(
                        child: IconButton(
                          iconSize: 30,
                          icon: const Icon(Icons.search, color: Colors.teal),
                          onPressed: () {
                            insertSubstringsToSearchKeywords();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ProductSearch(),
                            ));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              title: const Text(
                "Nour",
                style: TextStyle(
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
            body: navList[index],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: index,
              onTap: (value) {
                setState(() {
                  index = value;
                });
              },
              selectedItemColor: Colors.teal,
              unselectedItemColor: Colors.grey,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.local_offer),
                  label: S.of(context).offers,
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.production_quantity_limits),
                  label: S.of(context).myRequests,
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.favorite),
                  label: S.of(context).favourite,
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home),
                  label: S.of(context).home,
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      SystemNavigator.pop(); // Close the app
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  Future<void> deleteCurrentUser() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;
        CollectionReference users = FirebaseFirestore.instance.collection('users');
        await users.doc(userId).delete();
        await currentUser.delete();
        await FirebaseAuth.instance.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account successfully deleted.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please reauthenticate before deleting your account.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred while deleting your account.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while deleting your account.')),
      );
    }
  }
}
void insertSubstringsToSearchKeywords() async {
  final productsCollection = FirebaseFirestore.instance.collection('products');

  try {
    // Get all products
    final snapshot = await productsCollection.get();

    for (var doc in snapshot.docs) {
      final productName = doc['nameProduct'].toLowerCase();
      List<String> searchKeywords = [];

      // Generate substrings for the search keywords
      for (int i = 0; i < productName.length; i++) {
        for (int j = i + 1; j <= productName.length; j++) {
          searchKeywords.add(productName.substring(i, j));
        }
      }

      // Update the document to add substrings to the searchKeywords array
      await doc.reference.update({
        'searchKeywords': FieldValue.arrayUnion(searchKeywords)
      });

      print("Product '${doc['nameProduct']}' updated with substrings successfully.");
    }
  } catch (e) {
    print("Error updating product search keywords: $e");
  }
}

