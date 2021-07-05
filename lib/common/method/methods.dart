import 'package:flutter/material.dart';
import 'package:user_auth/page/conversation_page/conversation.dart';
import 'package:user_auth/page/forgot_password/forgot_password.dart';
import 'package:user_auth/page/jokes/jokes_category.dart';
import 'package:user_auth/page/search/search_page.dart';
import 'package:user_auth/page/sign_in/sign_in.dart';
import 'package:user_auth/page/sign_up/sign_up.dart';
import 'package:user_auth/page/user_details/user_details.dart';

showLoader(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              color: Colors.transparent,
            ),
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.orange),
                strokeWidth: 5,
                backgroundColor: Colors.white,
              ),
            )
          ],
        ),
      );
    },
  );
}

hideLoader(BuildContext context) {
  Navigator.of(context, rootNavigator: false).pop();
}

goSignIn(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
}

goSignUp(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
}

goForgotPassword(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => ForgotPassword()));
}

goUserDetails(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => UserDetails()));
}

goSearch(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
}

goConversation(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => Conversation()));
}

goJokeCategory(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => JokeCategory()));
}
