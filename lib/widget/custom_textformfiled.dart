import 'package:flutter/material.dart';

class CustomTextFiledWidget extends StatelessWidget {
  dynamic controller;
  dynamic validator;
  String? hintText;
  dynamic keyboardType;
  bool obscureText=false;

  CustomTextFiledWidget(
      {Key? key,
      this.controller,
      this.validator,
      this.hintText,
      this.keyboardType,
       required this.obscureText,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      //onChanged: ,
      //onSaved: ,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        
      ),
      //for UI to customize the keyboard
      keyboardType: keyboardType,
      
    );
  }
}
