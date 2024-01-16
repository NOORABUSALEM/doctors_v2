// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';

class reusedTextField extends StatelessWidget {
  reusedTextField(
      {super.key,
      required this.text,
      required this.icon,
      required this.ispassword,
      required this.controller,
      this.onChanged,
      this.validator});

  final String text;
  TextEditingController controller;
  final IconData icon;
  final bool ispassword;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: ispassword,
      enableSuggestions: !ispassword,
      autocorrect: !ispassword,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      decoration: InputDecoration(
          //senabledBorder: OutlineInputBorder(),
          prefixIcon: Icon(
            icon,
            color: Colors.white70,
          ),
          labelText: text,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Colors.white.withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none),
          )),
      onChanged: onChanged,
      validator: validator,
      keyboardType: ispassword
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
    );
  }
}
