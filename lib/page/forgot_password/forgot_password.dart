import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/constant/string_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/common/widget/common_app_bar.dart';
import 'package:user_auth/common/widget/widget.dart';
import 'package:user_auth/services/auth_service.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key key}) : super(key: key);

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  final forgotPassword = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return Scaffold(
      appBar: const CommonAppBar(title: StringResources.forgotPassword),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: forgotPassword,
              child: email(emailController, fontColor: ColorResource.white),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: elevatedButton(StringResources.get, () => getLink()),
          ),
        ],
      ),
    );
  }

  getLink() {
    if (forgotPassword.currentState.validate()) {
      forgotPassword.currentState.save();
      authService.forgotPassword(context, emailController.text);
    } else {
      Fluttertoast.showToast(
        msg: 'Enter valid email address.!',
        backgroundColor: ColorResource.red,
        textColor: ColorResource.white,
      );
    }
  }
}
