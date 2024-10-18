
// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable, camel_case_types
class ItemProduct extends StatelessWidget {
   ItemProduct({super.key, required this.image,required this.nameProduct,required this.Ontap});
  String image; 
  String nameProduct;
  Function()?Ontap;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:Ontap ,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(  
                      width: 100,
                      height: 100,
                       
                      decoration: BoxDecoration(
                        image: DecorationImage(image:NetworkImage(image) ),
                        border: const Border(),
                        color: const Color.fromARGB(255, 238, 236, 236),
                        borderRadius: BorderRadius.circular(20),
                       
                      ),
                      
                    
                       
                     ),
                     Text(nameProduct,
                     maxLines: 1,
                     style: const TextStyle(
                      overflow:TextOverflow.ellipsis,
                      
                      fontWeight: FontWeight.bold
                     ),
                     ),
        ],
      ),
    );
  }
}