import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/constant/string_res.dart';

import 'package:user_auth/common/widget/widget.dart';
import 'package:user_auth/services/auth_service.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final forgotPassword = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    print(runtimeType);
    return Scaffold(
      appBar: topMenuBar(context, '${StringResources.Title}'),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            titleText(StringResources.ForgotPass),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: forgotPassword,
                child: email(emailController),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: elevatedButton(StringResources.Get, () {
                getLink();
              }),
            ),
          ],
        ),
      ),
    );
  }

  getLink() {
    final isValid = forgotPassword.currentState.validate();

    if (isValid) {
      forgotPassword.currentState.save();
      print(emailController.text);
      authService.forgotPassword(context, emailController.text);
    } else {
      Fluttertoast.showToast(
        msg: 'Enter valid email address.!',
        backgroundColor: ColorResource.Red,
        textColor: ColorResource.White,
      );
    }
  }
}
