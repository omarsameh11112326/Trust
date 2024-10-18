// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yousef_nour/firebase_options.dart';
import 'package:yousef_nour/generated/l10n.dart';
import 'package:yousef_nour/screens/AuthPages/WelcomeScreen.dart';
import 'package:yousef_nour/screens/adminPannel/adminHold.dart';
import 'package:yousef_nour/screens/HomePages/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');
  bool _isLoggedIn = false;
  bool _isAdmin = false;  // New variable to track admin status
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _checkLoginState(); 
  }

  Future<void> _checkLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    bool isAdmin = prefs.getBool('isAdmin') ?? false;  // Check if the user is admin
    
    setState(() {
            _isAdmin = isAdmin;  // Update the admin status

      _isLoggedIn = isLoggedIn;
      _isInitialized = true;  
    });
  }

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      // Show a loading screen while initializing
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      locale: _locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      home: _isLoggedIn 
          ? (_isAdmin ? const AdminHold() : const Home())  
          : Welcome(onLanguageChange: _changeLanguage),
    );
  }
}
