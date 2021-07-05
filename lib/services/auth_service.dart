import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/model/user_model.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  UserModel userDetails;

  //     ======================= Get Current User Details & Check User Logged In or Not =======================     //
  Future<bool> userLogInCheck() async {
    bool login;
    try {
      var user = firebaseAuth.currentUser;
      if (user == null) {
        print('Hello, No user Found');
        login = false;
        return login;
      } else {
        print(user);
        print('Hello, This is current user : ${user.uid}');
        login = true;
        return login;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //     ======================= SignUp =======================     //
  Future<String> createUser(
      BuildContext context, String email, String password) async {
    try {
      showLoader(context);
      var authUser = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = authUser.user.uid.toString();
      print('Created User User Id : $userId');
      return userId;
    } catch (e) {
      print('Catch error in Verify User : $e');
      var error = e.toString().split(' ')[0];
      if (error == '[firebase_auth/email-already-in-use]') {
        Fluttertoast.showToast(
          msg: 'You already registered, Please Sign In.!',
          backgroundColor: ColorResource.Red,
          textColor: ColorResource.White,
        );
        hideLoader(context);
      }
      return null;
    }
  }

  //     ======================= SignIn =======================     //
  Future<UserCredential> verifyUser(
      BuildContext context, String email, String password) async {
    try {
      showLoader(context);
      var authUser = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return authUser;
    } catch (e) {
      print('Catch error in Verify User : $e');
      var error = e.toString().split(' ')[0];
      if (error == '[firebase_auth/wrong-password]') {
        Fluttertoast.showToast(
          msg: 'Please, Enter correct password',
          backgroundColor: ColorResource.Red,
          textColor: ColorResource.White,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'User not exist.!',
          backgroundColor: ColorResource.Red,
          textColor: ColorResource.White,
        );
      }
      hideLoader(context);
      return null;
    }
  }

  //     ======================= Forgot Password =======================     //
  forgotPassword(BuildContext context, String email) async {
    try {
      showLoader(context);
      await firebaseAuth.sendPasswordResetEmail(email: email);
      hideLoader(context);
    } catch (e) {
      print('Catch error in Verify User : $e');
      if (e.code == 'ERROR_USER_NOT_FOUND') {
        Fluttertoast.showToast(
          msg: 'You don\'t have account, Please Sign Up',
          backgroundColor: ColorResource.Red,
          textColor: ColorResource.White,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Enter Valid Email Address',
          backgroundColor: ColorResource.Red,
          textColor: ColorResource.White,
        );
      }
      hideLoader(context);
    }
  }

  //     ======================= SignOut =======================     //
  Future<void> userSignOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }


//     ======================= Google Sign In =======================     //
  Future signInWithGoogle(BuildContext context) async {
    try {
      showLoader(context);
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final credentials = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      var authResult = await firebaseAuth.signInWithCredential(credentials);
      return authResult;
    } catch (e) {
      print(e);
    }
  }


}
