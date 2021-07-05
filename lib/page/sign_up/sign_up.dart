import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/constant/string_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/common/widget/widget.dart';
import 'package:user_auth/model/user_model.dart';
import 'package:user_auth/services/auth_service.dart';
import 'package:user_auth/services/firebase_messaging.dart';
import 'package:user_auth/services/users_service.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final signUpFormKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPasswordController = TextEditingController();
  AuthService authService = AuthService();
  UserService userService = UserService();
  FirebaseNotification firebaseNotification = FirebaseNotification();
  UserModel userDetails;
  String token;

  @override
  Widget build(BuildContext context) {
    print(runtimeType);
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        appBar: topMenuBar(context, 'Firebase User Integration'),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              titleText('Register User'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Form(
                  key: signUpFormKey,
                  child: signUpForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget signUpForm() {
    return ListView(
      shrinkWrap: true,
      primary: false,
      children: [
        firstName(firstNameController),
        lastName(lastNameController),
        email(emailController),
        password(passwordController),
        confirmPassword(cPasswordController, passwordController),
        SizedBox(height: 30),
        elevatedButton(StringResources.Register, register),
        SizedBox(height: 20),
        textBody(StringResources.LogInRequest),
        SizedBox(height: 10),
        textHeader(goToSignIn, StringResources.SignUpOption),
        SizedBox(height: 20),
      ],
    );
  }

  goToSignIn() {
    goSignIn(context);
    setState(() {});
  }

  register() {
    final isValid = signUpFormKey.currentState.validate();

    if (isValid) {
      signUpFormKey.currentState.save();
      signUpValidation();
    } else {
      Fluttertoast.showToast(
        msg: 'Enter valid details',
        backgroundColor: ColorResource.Red,
        textColor: ColorResource.White,
      );
    }
  }

  Future<void> signUpValidation() async {
    var userId = await authService.createUser(
        context, emailController.text, passwordController.text);
    var token = await firebaseNotification.firebaseToken();
    print('Token Value : $token');

    userDetails = UserModel(
      uid: userId,
      fname: firstNameController.text,
      lname: lastNameController.text,
      email: emailController.text,
      token: token,
      type: 'Firebase',
    );

    if (userId != null) {
      await userService.createUser(userDetails);
      print('Sign Up Validation UserID : $userId');
      Fluttertoast.showToast(
        msg: '${userDetails.fname} \n Your account created successfully..!',
        backgroundColor: ColorResource.Orange,
        textColor: ColorResource.White,
      );
      hideLoader(context);
      goToSignIn();
    } else {
      Fluttertoast.showToast(
        msg: 'You already registered, Please Sign In.!',
        backgroundColor: ColorResource.Red,
        textColor: ColorResource.White,
      );
    }
  }
}
