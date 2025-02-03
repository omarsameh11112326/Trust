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
    return SizedBox(
      height: 50,
      width:  MediaQuery.of(context).size.width*0.86,
      child: ElevatedButton(
              onPressed: OnPressed,
              
              style: ElevatedButton.styleFrom(
                
      
                backgroundColor:  const Color(0xFF2F019E),
                elevation: 0,
                side: const BorderSide(
                  style: BorderStyle.solid,
                color: Color.fromARGB(255, 255, 255, 255)
                ),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), 
  ),
              ), 
              child:  Text(ButtonText,
              style: const TextStyle(
                color:  Color.fromARGB(255, 255, 255, 255),
                fontSize: 26
              ),
              ),
         
            
            ),
    );
  }
}