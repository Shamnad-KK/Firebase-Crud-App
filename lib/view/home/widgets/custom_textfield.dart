import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    required this.keyboardType,
  });
  final String hintText;
  final bool isPassword;
  final bool obscure;
  final VoidCallback? suffixOntap;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool readOnly;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscure,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 0.2.w),
          borderRadius: BorderRadius.circular(30.r),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
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
