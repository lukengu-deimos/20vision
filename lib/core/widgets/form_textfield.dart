import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_palette.dart';

class FormTextField extends StatelessWidget {

  final String label;
  final TextEditingController controller;
  bool? obscureText;
  final TextInputType keyboardType;
  final bool enabled;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final TextInputAction? textInputAction;


  FormTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.maxLengthEnforcement,
    this.textInputAction
  });

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      controller: controller,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      obscureText: obscureText?? false,
      keyboardType:keyboardType,
      validator: validator,
      textInputAction: textInputAction,
      style: const TextStyle(
        color: AppPalette.lightGray,
        fontSize: 14
      ),
      decoration: InputDecoration(
        labelText: label,
        fillColor: Colors.white,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelStyle: const TextStyle(
          color: AppPalette.lightGray,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0,
            horizontal: 20.0),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
      maxLines: maxLines,


    );
  }

}