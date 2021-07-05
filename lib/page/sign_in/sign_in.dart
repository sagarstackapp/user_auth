import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/constant/string_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/common/widget/widget.dart';
import 'package:user_auth/model/user_model.dart';
import 'package:user_auth/services/auth_service.dart';
import 'package:user_auth/services/users_service.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final signInFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  AuthService authService = AuthService();
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    print(runtimeType);
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        appBar: topMenuBar(context, '${StringResources.Title}'),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              titleText(StringResources.SignIn),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Form(
                  key: signInFormKey,
                  child: signInForm(
                    emailController,
                    passwordController,
                    goToForgotPassword,
                    signUp,
                    goToSignUp,
                    context,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget signInForm(
      TextEditingController emailController,
      TextEditingController passwordController,
      GestureTapCallback onTap,
      VoidCallback onPressed,
      GestureTapCallback headerTap,
      BuildContext context) {
    return ListView(
      shrinkWrap: true,
      primary: false,
      children: [
        email(emailController),
        password(passwordController),
        SizedBox(height: 20),
        forgotPassword(onTap),
        SizedBox(height: 30),
        elevatedButton(StringResources.SignIn, onPressed),
        SizedBox(height: 20),
        textBody(StringResources.AccountRequest),
        SizedBox(height: 10),
        textHeader(headerTap, StringResources.SignInOption),
        SizedBox(height: 10),
        textBody('OR'),
        google(context),
        facebook(context),
      ],
    );
  }

  signUp() {
    final isValid = signInFormKey.currentState.validate();

    if (isValid) {
      signInFormKey.currentState.save();

      signInValidation(emailController, passwordController);
    } else {
      Fluttertoast.showToast(
        msg: 'Enter valid details',
        backgroundColor: ColorResource.Red,
        textColor: ColorResource.White,
      );
    }
  }

  Future<void> signInValidation(TextEditingController emailController,
      TextEditingController passwordController) async {
    var userCredentials = await authService.verifyUser(
        context, emailController.text, passwordController.text);
    if (userCredentials != null) {
      hideLoader(context);
      Fluttertoast.showToast(
        msg: 'Hey, ${userCredentials.user.email}',
        backgroundColor: ColorResource.Orange,
        textColor: ColorResource.White,
      );
      print('Current user details : ${userCredentials.user}');
      // goToUserDetails();
      goToSearch();
    } else {
      print('User Details are null');
      Fluttertoast.showToast(
        msg: 'Something went wrong.!',
        backgroundColor: ColorResource.Orange,
        textColor: ColorResource.White,
      );
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    var authResult = await authService.signInWithGoogle(context);
    String googleUserId = authResult.user.uid.toString();
    print('Google Created User User Id : $googleUserId');
    print('Current GOOGLE USER : ${authResult.additionalUserInfo.profile}');
    UserModel userDetails = UserModel(
      email: authResult.additionalUserInfo.profile['email'],
      lname: authResult.additionalUserInfo.profile['family_name'],
      fname: authResult.additionalUserInfo.profile['given_name'],
      image: authResult.additionalUserInfo.profile['picture'],
      uid: authResult.user.uid,
      type: 'Google',
    );

    // Response From Google
    // AdditionalUserInfo(isNewUser: false, profile: {given_name: Sagar, locale: en-GB, family_name: Stackapp, picture: https://lh3.googleusercontent.com/a-/AOh14GhbQy7Z7p1OZg1fh_Fuhn98k-_vQWpY7JFpRZET=s96-c, aud: 17508847403-e70i2j76t12vnglbdmgpj275s7tg6adm.apps.googleusercontent.com, azp: 17508847403-ts2adlcaj5upuis3fk15bepcr4msanlu.apps.googleusercontent.com, exp: 1620971700, iat: 1620968100, iss: https://accounts.google.com, sub: 111037160002170854379, name: Sagar Stackapp, email: sagaranghan.stackapp@gmail.com, email_verified: true}, providerId: google.com, username: null)
    await userService.createUser(userDetails);
    goToSearch();
    // goUserDetails(context);
  }

  Widget forgotPassword(GestureTapCallback onTap) {
    return Container(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: onTap,
        child: Text(
          '${StringResources.ForgotPass}?',
          style: TextStyle(
            fontSize: 18,
            color: ColorResource.White,
            wordSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget google(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SignInButton(
        buttonType: ButtonType.google,
        width: double.infinity,
        buttonSize: ButtonSize.large,
        onPressed: () {
          signInWithGoogle(context);
        },
      ),
    );
  }

  Widget facebook(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SignInButton(
        buttonType: ButtonType.facebook,
        width: double.infinity,
        buttonSize: ButtonSize.large,
        onPressed: () {
          Fluttertoast.showToast(
            msg: 'Implementation left',
            backgroundColor: ColorResource.Red,
            textColor: ColorResource.White,
          );
        },
      ),
    );
  }

  goToSignUp() {
    goSignUp(context);
    setState(() {});
  }

  goToForgotPassword() {
    goForgotPassword(context);
    setState(() {});
  }

  goToUserDetails() {
    goUserDetails(context);
    setState(() {});
  }

  goToSearch() {
    goSearch(context);
    setState(() {});
  }
}
