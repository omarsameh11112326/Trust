
// ignore_for_file: use_build_context_synchronously, avoid_print, duplicate_ignore, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:yousef_nour/components/CustomTextFormField.dart';
import 'package:yousef_nour/components/button.dart';
import 'package:yousef_nour/generated/l10n.dart';
import 'package:yousef_nour/screens/HomePages/home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = '';
  String password = '';
  String phoneNumber = '';
  String firstName = '';
  String lastName = '';
  bool _isLoading = false;
  TextEditingController firstController=TextEditingController();
  TextEditingController lastController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();


String? dropDownValue; // Nullable String to allow null initially

  @override
  void initState() {
    super.initState();
    // Initialize dropdown value after context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        dropDownValue = S.of(context).normalUser; // Initialize dropdown with a valid value
      });
    });
  }


  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    
    return _isLoading // Show progress indicator if loading
                    ? Scaffold(
                      body: Center(
                                        child: Lottie.network(
                      "https://lottie.host/5284eb0c-9d6f-442f-82d8-cc9fe85ba642/DQp1XQwrwH.json",
                      height: MediaQuery.of(context).size.height * 0.30,
                                        ),
                                      ),
                    ):
    Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 250),
                DropdownButton(
                  value: dropDownValue,
                  style: const TextStyle(color: Colors.teal),
                  items:  [
                    DropdownMenuItem(
                      value: S.of(context).normalUser,
                      child: Text(S.of(context).normalUser),
                    ),
                    DropdownMenuItem(
                      value: S.of(context).merchant,
                      child: Text(S.of(context).merchant),
                    ),
                  ],
                  onChanged: dropCallBack,
                ),
                CustomTextFormField(
                  icon: const Icon(Icons.text_fields),
                  label:S.of(context).EnterYourFirstName,
                  textInputType: TextInputType.name,
                  inputString: (data) {
                    firstName = data;
                  }, controller: firstController,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  icon: const Icon(Icons.text_fields),
                  label: S.of(context).EnterYourLastName,
                  textInputType: TextInputType.name,
                  inputString: (data) {
                    lastName = data;
                  }, controller: lastController,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  icon: const Icon(Icons.phone),
                  label:S.of(context).EnterYourPhoneNumber,
                  textInputType: TextInputType.phone,
                  inputString: (data) {
                    phoneNumber = data;
                  }, controller: phoneController,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  icon: const Icon(Icons.email),
                  label: S.of(context).EnterYourEmail,
                  textInputType: TextInputType.emailAddress,
                  inputString: (data) {
                    email = data;
                  }, 
                  controller: emailController,
                  
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  icon: const Icon(Icons.remove_red_eye),
                  label: S.of(context).password,
                  textInputType: TextInputType.visiblePassword,
                  inputString: (data) {
                    password = data;
                  },
                  isPassword: true, controller: passwordController,
                ),
                const SizedBox(height: 10),
                CustomButton(
                  ButtonText: S.of(context).signUp,
                  OnPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await auth(email, password);
                      await addUserToFirebase();

                  
                      emailController.clear();
                      passwordController.clear();
                      firstController.clear();
                      lastController.clear();
                      phoneController.clear();
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

  void dropCallBack(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        dropDownValue = selectedValue;
      });
    }
  }

  Future<void> auth(String email, String password) async {
   
    try {
      var auth = FirebaseAuth.instance;
       await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The password provided is too weak.')),
        );
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The account already exists for that email.')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  }

  Future<void> addUserToFirebase() async {
   
      setState(() {
        _isLoading = false; // Hide the indicator
      });
    
    try {
        final User? currentUser = FirebaseAuth.instance.currentUser;
    String userId = currentUser!.uid;     
       CollectionReference users = FirebaseFirestore.instance.collection('users');
      await users.doc(userId).set({
        "email": email,
        "password": password,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "userType": dropDownValue,
      });
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign up. Please try again later.')),
      );
    }finally {
      setState(() {
        _isLoading = false; // Hide the indicator
      });
    }
    }
  }

