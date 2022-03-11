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

  //     ======================= Get Current User Details & Check User Logged In or Not =======================     //
  Future<bool> userLogInCheck() async {
    bool login;
    try {
      var user = firebaseAuth.currentUser;
      if (user == null) {
        logs('Hello, No user Found');
        login = false;
        return login;
      } else {
        logs('Current user --> $user');
        logs('Hello, This is current user : ${user.uid}');
        login = true;
        return login;
      }
    } catch (e) {
      logs(e.toString());
      return null;
    }
  }

  //     ======================= SignUp =======================     //
  Future<UserCredential> createUser(String email, String password) async {
    try {
      UserCredential authUser =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = authUser.user.uid.toString();
      logs('Created User User Id : $userId');
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
        email: email,
        password: password,
      );
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
      showLoader(context);
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      logs('Catch error in Verify User : $e');
      if (e.code == 'ERROR_USER_NOT_FOUND') {
        Fluttertoast.showToast(
          msg: 'You don\'t have account, Please Sign Up',
          backgroundColor: ColorResource.red,
          textColor: ColorResource.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Enter Valid Email Address',
          backgroundColor: ColorResource.red,
          textColor: ColorResource.white,
        );
      }
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
