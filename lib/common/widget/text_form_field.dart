import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_auth/common/constant/color_res.dart';

class CommonTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final FormFieldValidator<String> validator;
  final List<TextInputFormatter> inputFormatters;
  final String hintText;
  final Color color;
  final Color fontColor;
  final bool autoFocus;
  final TextInputType keyboardType;
  final IconData prefixIcon;

  const CommonTextFormField({
    Key key,
    @required this.controller,
    @required this.hintText,
    this.obscureText = false,
    this.validator,
    this.color,
    this.fontColor = ColorResource.darkGreen,
    this.autoFocus = false,
    this.inputFormatters,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 18),
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        autofocus: autoFocus,
        keyboardType: keyboardType,
        textAlign: TextAlign.start,
        inputFormatters: inputFormatters,
        obscureText: obscureText,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(
          fontSize: 18,
          color: fontColor,
          wordSpacing: 1,
          letterSpacing: 1,
        ),
        validator: validator,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: ColorResource.grey,
            fontSize: 16,
            wordSpacing: 2,
            letterSpacing: 1,
          ),
          labelText: hintText,
          labelStyle: const TextStyle(
            color: ColorResource.grey,
            fontSize: 16,
            wordSpacing: 2,
            letterSpacing: 1,
          ),
          prefixIcon:
              Icon(prefixIcon, color: fontColor ?? ColorResource.darkGreen),
          prefixIconColor: ColorResource.darkGreen,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: ColorResource.darkGreen),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: ColorResource.darkGreen),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: ColorResource.darkGreen),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: ColorResource.red),
          ),
          contentPadding: const EdgeInsets.fromLTRB(30, -16, 0, 50),
          suffixIconConstraints: const BoxConstraints(minWidth: 2),
          isDense: true,
        ),
      ),
    );
  }
}
