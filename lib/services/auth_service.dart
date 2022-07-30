import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:user_auth/common/app/shared_preference.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/model/user_model.dart';
import 'package:user_auth/services/users_service.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  UserModel userDetails;
  UserService userService = UserService();

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
  Future<void> userSignOut(BuildContext context) async {
    await userService.deleteToken(context);
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
    await removePrefValue(isLogIn);
    await removePrefValue(isSocialLogin);
  }

  //     ======================= Google Sign In =======================     //
  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final credentials = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        UserCredential authResult =
            await firebaseAuth.signInWithCredential(credentials);
        return authResult;
      }
      return null;
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

  //     ======================= PhoneNumber Sign In =======================     //
  Future<UserCredential> signInWithMobileNumber(BuildContext context,
      {@required String phoneNumber, @required String smsCode}) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          UserCredential userCredential =
              await firebaseAuth.signInWithCredential(phoneAuthCredential);
          logs('User --> ${userCredential.user}');
        },
        verificationFailed: (FirebaseAuthException error) {
          if (error.code == 'invalid-phone-number') {
            showMessage(context, 'The provided phone number is not valid.');
          } else if (error.code == 'firebase_auth/invalid-verification-code') {
            showMessage(context, 'The provided OTP is not valid.');
          } else {
            showMessage(context, error.message);
          }
        },
        codeSent: (String verificationId, int forceResendingToken) async {
          PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: smsCode);
          UserCredential userCredential =
              await firebaseAuth.signInWithCredential(phoneAuthCredential);
          logs('User --> ${userCredential.user}');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          logs('VerifyId --> $verificationId');
        },
        timeout: const Duration(seconds: 30),
      );
      return null;
    } on FirebaseException catch (e) {
      logs('Catch error in Verify User : ${e.message}');
      showMessage(context, e.message);
      return null;
    }
  }
}
