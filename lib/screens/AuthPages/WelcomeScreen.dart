// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:yousef_nour/components/button.dart';
import 'package:yousef_nour/generated/l10n.dart';
import 'package:yousef_nour/screens/AuthPages/login.dart';
import 'package:yousef_nour/screens/AuthPages/signUp.dart';

class Welcome extends StatefulWidget {
  final Function(Locale locale) onLanguageChange;

  const Welcome({super.key, required this.onLanguageChange});

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool isEnglish = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('العربية'),
              Switch(
                activeColor: Colors.teal,
                inactiveTrackColor: Colors.white,

                value: isEnglish,
                onChanged: (value) {
                  setState(() {
                    isEnglish = value;
                    if (isEnglish) {
                      widget.onLanguageChange(const Locale('en'));
                    } else {
                      widget.onLanguageChange(const Locale('ar'));
                    }
                  });
                },
              ),
              const Text('English'),
            ],
          ),
          const SizedBox(height: 100,),
          Center(
            child: Lottie.network(
              "https://lottie.host/3470a0ed-b54f-4fcd-923a-6985aabcb4e2/Nqh7DuTFcQ.json",
            ),
          ),
          Text(
            S.of(context).WelcomeBack,
            style: const TextStyle(
              color: Colors.teal,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          CustomButton(
            ButtonText: S.of(context).login,
            OnPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const LogIn();
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 3),
          CustomButton(
            ButtonText: S.of(context).signUp,
            OnPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUp();
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 20),
         
        ],
      ),
    );
  }
}
