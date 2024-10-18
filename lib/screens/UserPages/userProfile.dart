// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:yousef_nour/components/button.dart';
import 'package:yousef_nour/generated/l10n.dart';
import 'package:yousef_nour/screens/UserPages/editUserProfile.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    if (currentUser == null) {
      return const Center(child: Text("No user is currently signed in"));
    }

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(currentUser.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Error fetching user data.')),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text('No data found for this user.')),
          );
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final String firstName = userData['firstName'] ?? 'No name';
        final String lastName = userData['lastName'] ?? 'No name';
        final String email = userData['email'] ?? 'No email';
        final String phoneNumber = userData['phoneNumber'] ?? 'No phone';
        final String userType = userData['userType'] ?? 'No type';

        return Scaffold(
          appBar: AppBar(
            title: Text(
              S.of(context).MyProfile,
              style: const TextStyle(color: Colors.teal),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
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
                Center(
                  child: Text(
                    
                    "$firstName $lastName",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                    ),
                    ),
                ),
                const SizedBox(height: 20,),

                  Text(S.of(context).firstName,
                  style: const TextStyle(
                    color: Colors.teal,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  Text(firstName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Text(S.of(context).lastName,
                  style: const TextStyle(
                    color: Colors.teal,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  Text(lastName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Text(S.of(context).email,
                  style: const TextStyle(
                    color: Colors.teal,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  Text(email,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Text(S.of(context).phone,
                  style: const TextStyle(
                    color: Colors.teal,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  Text(phoneNumber,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Text(S.of(context).userType,
                  style: const TextStyle(
                    color: Colors.teal,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  Text(userType,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Center(
                    child: CustomButton(ButtonText: S.of(context).editProfile, OnPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return editUserProfile(firstName: firstName,lastName: lastName,phone: phoneNumber, userType:userType,);
                      }));
                    }),
                  )


                
              ],
            ),
          ),
        );
      },
    );
  }
}
