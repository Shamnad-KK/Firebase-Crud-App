import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.suffixOntap,
    this.obscure = false,
    required this.controller,
    this.validator,
    this.readOnly = false,
  });
  final String hintText;
  final bool isPassword;
  final bool obscure;
  final VoidCallback? suffixOntap;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscure,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hintText,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        suffixIcon: isPassword == true
            ? IconButton(
                onPressed: suffixOntap,
                icon: obscure == true
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
              )
            : null,
      ),
    );
  }
}
