import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
   // ignore: non_constant_identifier_names
   CustomButton({super.key,required this.ButtonText,required this.OnPressed});
// ignore: non_constant_identifier_names
String ButtonText;
// ignore: non_constant_identifier_names
Function()  OnPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
            onPressed: OnPressed,
            style: ElevatedButton.styleFrom(

              backgroundColor:  const Color.fromARGB(255, 255, 255, 255),
              elevation: 0,
              side: const BorderSide(style: BorderStyle.solid,
              color: Colors.teal
              
              )
            ), 
            child:  Text(ButtonText,
            style: const TextStyle(
              color: Colors.teal,
              fontSize: 26
            ),
            ),
       
          
          );
  }
}