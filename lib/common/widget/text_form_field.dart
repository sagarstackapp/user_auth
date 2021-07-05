import 'package:flutter/material.dart';
import 'package:user_auth/common/constant/color_res.dart';

// ignore: must_be_immutable
class CommonTextFormField extends StatelessWidget {
  TextEditingController controller;
  bool obscureText;
  FormFieldValidator validator;
  String hintText;
  Color color;
  bool autoFocus;

    CommonTextFormField({
    @required this.controller,
    this.obscureText = false,
    this.validator,
    @required this.hintText,
    this.color,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: autoFocus ?? false,
      keyboardType: TextInputType.emailAddress,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: 18,
        color: ColorResource.White,
        wordSpacing: 1,
        letterSpacing: 1,
      ),
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: TextStyle(
          color: ColorResource.Grey,
          fontSize: 15,
          wordSpacing: 2,
          letterSpacing: 1,
          height: 3,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color ?? ColorResource.White),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color ?? ColorResource.White),
        ),
      ),

    );
  }
}


