// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:yousef_nour/components/button.dart';
import 'package:yousef_nour/generated/l10n.dart';
import 'package:yousef_nour/screens/AuthPages/login.dart';
import 'package:yousef_nour/screens/AuthPages/signUp.dart';

class WelcomeScreen extends StatefulWidget {
  final Function(Locale locale) onLanguageChange;

  const WelcomeScreen({super.key, required this.onLanguageChange});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  bool isEnglish = true;
 
  @override


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('العربية'),
              Switch(
                activeColor: const Color(0xFF2F019E),
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
          

           Center(

            child: Image.asset('assets/TRUST LOGO PNBG.png'),
            
            
             ), 
                     const Spacer(
                      flex: 1,
                     ),

          Text(
            S.of(context).WelcomeBack,
            style: const TextStyle(
              color: Color(0xFF2F019E),
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
          const SizedBox(height: 5),
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
const Spacer(
                      flex: 2,
                     ),
        ],
      ),
    );
  }
}
