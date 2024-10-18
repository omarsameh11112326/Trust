// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, file_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Method to delete a user by ID
  Future<void> deleteUser(String userId) async {
    try {
      await users.doc(userId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User successfully deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete user')),
      );
    }
  }

  // Method to update a user by ID
  Future<void> updateUser(String userId, Map<String, dynamic> newData) async {
    try {
      await users.doc(userId).update(newData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User successfully updated')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update user')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading users'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          final userList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              var user = userList[index].data() as Map<String, dynamic>;
              var userId = userList[index].id;
              var firstName = user['firstName'] ?? 'No name';
              var lastName = user['lastName'] ?? 'No name';
              var phoneNumber = user['phoneNumber'] ?? 'No name';

              return ListTile(
                title: Text('$firstName $lastName'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // You can add a dialog or another screen to update user data
                        showDialog(
                          context: context,
                          builder: (context) {
                            final TextEditingController firstNameController = TextEditingController(text: firstName);
                            final TextEditingController lastNameController = TextEditingController(text: lastName);
                            final TextEditingController PhoneController = TextEditingController(text: phoneNumber);
                            return AlertDialog(
                              title: const Text('Update User'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: firstNameController,
                                    decoration: const InputDecoration(labelText: 'First Name'),
                                  ),
                                  TextField(
                                    controller: lastNameController,
                                    decoration: const InputDecoration(labelText: 'Last Name'),
                                  ),
                                  TextField(
                                    controller: PhoneController,
                                    decoration: const InputDecoration(labelText: 'Phone number'),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    updateUser(userId, {
                                      'firstName': firstNameController.text,
                                      'lastName': lastNameController.text,
                                      'phoneNumber': phoneNumber.text,
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Update'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteUser(userId);
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
