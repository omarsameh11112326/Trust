// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Favourite`
  String get favourite {
    return Intl.message(
      'Favourite',
      name: 'favourite',
      desc: '',
      args: [],
    );
  }

  /// `My Requests`
  String get myRequests {
    return Intl.message(
      'My Requests',
      name: 'myRequests',
      desc: '',
      args: [],
    );
  }

  /// `Offers`
  String get offers {
    return Intl.message(
      'Offers',
      name: 'offers',
      desc: '',
      args: [],
    );
  }

  /// `Normal user`
  String get normalUser {
    return Intl.message(
      'Normal user',
      name: 'normalUser',
      desc: '',
      args: [],
    );
  }

  /// `Merchant`
  String get merchant {
    return Intl.message(
      'Merchant',
      name: 'merchant',
      desc: '',
      args: [],
    );
  }

  /// `Enter your first name`
  String get EnterYourFirstName {
    return Intl.message(
      'Enter your first name',
      name: 'EnterYourFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your last name`
  String get EnterYourLastName {
    return Intl.message(
      'Enter your last name',
      name: 'EnterYourLastName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get EnterYourPhoneNumber {
    return Intl.message(
      'Enter your phone number',
      name: 'EnterYourPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get EnterYourEmail {
    return Intl.message(
      'Enter your email',
      name: 'EnterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `last Name`
  String get lastName {
    return Intl.message(
      'last Name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phone {
    return Intl.message(
      'Phone number',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get password {
    return Intl.message(
      'Enter your password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get login {
    return Intl.message(
      'Log in',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUp {
    return Intl.message(
      'Sign up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get DontHaveAnAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'DontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back !`
  String get WelcomeBack {
    return Intl.message(
      'Welcome Back !',
      name: 'WelcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message(
      'Contact Us',
      name: 'contactUs',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get signOut {
    return Intl.message(
      'Log Out',
      name: 'signOut',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `My Profile`
  String get MyProfile {
    return Intl.message(
      'My Profile',
      name: 'MyProfile',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get aboutUs {
    return Intl.message(
      'About Us',
      name: 'aboutUs',
      desc: '',
      args: [],
    );
  }

  /// `User Type`
  String get userType {
    return Intl.message(
      'User Type',
      name: 'userType',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get upDate {
    return Intl.message(
      'Update',
      name: 'upDate',
      desc: '',
      args: [],
    );
  }

  /// `Policy`
  String get policy {
    return Intl.message(
      'Policy',
      name: 'policy',
      desc: '',
      args: [],
    );
  }

  /// `Delete `
  String get delete {
    return Intl.message(
      'Delete ',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteYourAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Add Product`
  String get addProduct {
    return Intl.message(
      'Add Product',
      name: 'addProduct',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get Submit {
    return Intl.message(
      'Submit',
      name: 'Submit',
      desc: '',
      args: [],
    );
  }

  /// `Product Details`
  String get ProductDetails {
    return Intl.message(
      'Product Details',
      name: 'ProductDetails',
      desc: '',
      args: [],
    );
  }

  /// `price`
  String get price {
    return Intl.message(
      'price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Paper Products`
  String get PaperProducts {
    return Intl.message(
      'Paper Products',
      name: 'PaperProducts',
      desc: '',
      args: [],
    );
  }

  /// `Dishwashing Detergents`
  String get DishwashingDetergents {
    return Intl.message(
      'Dishwashing Detergents',
      name: 'DishwashingDetergents',
      desc: '',
      args: [],
    );
  }

  /// `Cups`
  String get Cups {
    return Intl.message(
      'Cups',
      name: 'Cups',
      desc: '',
      args: [],
    );
  }

  /// `Bags`
  String get Bags {
    return Intl.message(
      'Bags',
      name: 'Bags',
      desc: '',
      args: [],
    );
  }

  /// `Foil Bags`
  String get FoilBags {
    return Intl.message(
      'Foil Bags',
      name: 'FoilBags',
      desc: '',
      args: [],
    );
  }

  /// `West Richards Shower Shampoo`
  String get WestRichardsShowerShampoo {
    return Intl.message(
      'West Richards Shower Shampoo',
      name: 'WestRichardsShowerShampoo',
      desc: '',
      args: [],
    );
  }

  /// `sanitary napkins`
  String get sanitarynapkins {
    return Intl.message(
      'sanitary napkins',
      name: 'sanitarynapkins',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get general {
    return Intl.message(
      'General',
      name: 'general',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
