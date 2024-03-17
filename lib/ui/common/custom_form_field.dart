import 'package:flutter/material.dart';

typedef MyValidator = String? Function(String?);

class CustomFormField extends StatelessWidget {
  CustomFormField(
      {required this.hint,
      required this.controller,
      required this.validator,
      this.keyboardType = TextInputType.text,
      this.secureText = false,
      super.key});

  bool secureText;
  String hint;
  TextInputType keyboardType;
  MyValidator validator;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: secureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: hint,
      ),
    );
  }
}
