// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yousef_nour/components/CustomTextFormField.dart';
import 'package:yousef_nour/components/button.dart';
import 'package:yousef_nour/generated/l10n.dart';
import 'package:yousef_nour/screens/adminPannel/adminHold.dart';
import 'package:yousef_nour/screens/HomePages/home.dart';
import 'package:yousef_nour/screens/AuthPages/signUp.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false; // Add a loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                        const Spacer(flex: 2,),

               Center(
        
          child: Image.asset('assets/TRUST LOGO PNBG.png'),
          
          
           ), 
                   const Spacer(
                    flex: 1,
                   ),
              CustomTextFormField(
                icon: const Icon(Icons.email),
                label: S.of(context).EnterYourEmail,
                textInputType: TextInputType.emailAddress,
                inputString: (data) {},
                controller: emailController,
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                icon: const Icon(Icons.remove_red_eye),
                label: S.of(context).password,
                textInputType: TextInputType.visiblePassword,
                inputString: (data) {},
                isPassword: true,
                controller: passwordController,
              ),
              const SizedBox(height: 5),
              isLoading
                  ? const CircularProgressIndicator() 
                  : CustomButton(
                      ButtonText: S.of(context).login,
                      OnPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true; 
                          });
        
                          bool signInSuccess = await signInFun(
                            emailController.text,
                            passwordController.text,
                          );
        
                          setState(() {
                            isLoading = false; // Hide loading state
                          });
        
                          if (signInSuccess) {
                            passwordController.clear();
                            emailController.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Login failed. Please check your credentials.'),
                              ),
                            );
                          }
                        }
                      },
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).DontHaveAnAccount,
                    style: const TextStyle(fontSize: 12),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignUp(),
                        ),
                      );
                    },
                    child: Text(
                      S.of(context).signUp,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF2F019E)),
                    ),
                  ),
                ],
              ),
              const Spacer(
                      flex: 2,
                     ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> signInFun(String emailAddress, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      bool isAdmin = emailAddress == "admin@admin.com" && password == "admin1";
      await prefs.setBool('isAdmin', isAdmin);

      if (!mounted) return false; 

      if (isAdmin) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AdminHold()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user found for that email.')),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wrong password provided for that user.')),
        );
      }
      return false;
    }
  }
}
