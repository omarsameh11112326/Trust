// ignore_for_file: must_be_immutable, library_private_types_in_public_api, file_names, implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart';

class CustomTextFormField extends StatefulWidget {
  final String label;
  final Icon icon;
  final Function(String) inputString;
  final TextInputType textInputType;
  final bool isPassword;
TextEditingController controller =TextEditingController();

  CustomTextFormField({
    super.key,
    required this.label,
    required this.icon,
    required this.inputString,
    required this.textInputType,
    required this.controller,
    this.isPassword = false,  List<TextInputFormatter>? inputFormatters,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      
      onChanged: widget.inputString,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Field is required';
        }
        return null;
      },
      keyboardType: widget.textInputType,
      obscureText: widget.isPassword ? _isObscured : false,
      cursorColor: const Color(0xFF2F019E),
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusColor: const Color(0xFF2F019E),
        fillColor: const Color(0xFF2F019E),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color:  Color(0xFF2F019E)),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 95, 91, 186)),
          borderRadius: BorderRadius.circular(15),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF2F019E),
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : widget.icon,
        suffixIconColor:  const Color(0xFF2F019E),
        label: Text(widget.label),
        labelStyle: const TextStyle(color:  Color(0xFF2F019E)),
      ),
    );
  }
}
