// ignore_for_file: camel_case_types, file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class drawerItem1 extends StatelessWidget {
   const drawerItem1({super.key, required this.icon, required this.label,required this.OnTap});
  final Icon icon;
  final String label;
 final Function()?OnTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: OnTap,
      child: Row(
         mainAxisSize:MainAxisSize.max ,  

        children: [
                 icon,
           const SizedBox(width: 10,),
          Text(label,
          
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          )
                  ],
         ),
    );
  }
}