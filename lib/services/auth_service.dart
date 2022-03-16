import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/model/user_model.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  UserModel userDetails;

  //     ======================= SignUp =======================     //
  Future<UserCredential> createUser(String email, String password) async {
    try {
      UserCredential authUser = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      logs('User data : ${authUser.user}');
      return authUser;
    } on FirebaseAuthException catch (e) {
      logs('Catch error in Create User --> ${e.message}');
      Fluttertoast.showToast(
        msg: e.message,
        backgroundColor: ColorResource.red,
        textColor: ColorResource.white,
      );
      return null;
    }
  }

  //     ======================= SignIn =======================     //
  Future<UserCredential> verifyUser(
      BuildContext context, String email, String password) async {
    try {
      UserCredential authUser = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      logs('User data : ${authUser.user}');
      return authUser;
    } on FirebaseException catch (e) {
      logs('Catch error in Verify User --> ${e.message}');
      Fluttertoast.showToast(
        msg: e.message.split('. ')[0].trim(),
        backgroundColor: ColorResource.red,
        textColor: ColorResource.white,
      );
      return null;
    }
  }

  //     ======================= Forgot Password =======================     //
  forgotPassword(BuildContext context, String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
        msg: 'Please check your $email account.!',
        backgroundColor: ColorResource.red,
        textColor: ColorResource.white,
      );
    } on FirebaseException catch (e) {
      logs('Catch error in Forgot Password --> ${e.message}');
      Fluttertoast.showToast(
        msg: e.message.split('. ')[0].trim(),
        backgroundColor: ColorResource.red,
        textColor: ColorResource.white,
      );
    }
  }

  //     ======================= SignOut =======================     //
  Future<void> userSignOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }

  //     ======================= Google Sign In =======================     //
  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final credentials = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      UserCredential authResult =
          await firebaseAuth.signInWithCredential(credentials);
      return authResult;
    } on FirebaseException catch (e) {
      logs('Catch error in Verify User : ${e.message}');
      Fluttertoast.showToast(
        msg: e.message,
        backgroundColor: ColorResource.red,
        textColor: ColorResource.white,
      );
      return null;
    }
  }

  //     ======================= Facebook Sign In =======================     //
  Future<UserCredential> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance
          .login(permissions: ['email', 'public_profile']);
      logs('Result --> ${result.status}');
      switch (result.status) {
        case LoginStatus.success:
          final OAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(result.accessToken.token);
          UserCredential authResult = await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential);
          return authResult;
          break;
        case LoginStatus.cancelled:
          return null;
          break;
        case LoginStatus.failed:
          return null;
          break;
        default:
          return null;
          break;
      }
    } on FirebaseException catch (e) {
      logs('Catch error in Verify User : ${e.message}');
      Fluttertoast.showToast(
        msg: e.message,
        backgroundColor: ColorResource.red,
        textColor: ColorResource.white,
      );
      return null;
    }
  }
}
