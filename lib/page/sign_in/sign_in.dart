import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import 'package:user_auth/common/app/shared_preference.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/constant/image_res.dart';
import 'package:user_auth/common/constant/string_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/common/widget/common_image_assets.dart';
import 'package:user_auth/common/widget/common_loader.dart';
import 'package:user_auth/common/widget/elevated_button.dart';
import 'package:user_auth/common/widget/widget.dart';
import 'package:user_auth/model/user_model.dart';
import 'package:user_auth/page/forgot_password/forgot_password.dart';
import 'package:user_auth/page/search/search_page.dart';
import 'package:user_auth/page/sign_up/sign_up.dart';
import 'package:user_auth/services/auth_service.dart';
import 'package:user_auth/services/firebase_messaging.dart';
import 'package:user_auth/services/users_service.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key key}) : super(key: key);

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  final signInFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  AuthService authService = AuthService();
  UserService userService = UserService();
  FirebaseNotification firebaseNotification = FirebaseNotification();

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return Scaffold(
      backgroundColor: ColorResource.white,
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: const CommonImageAsset(image: ImageResources.login),
              ),
              const Text(
                'Welcome back!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Form(
                  key: signInFormKey,
                  child: Column(
                    children: [
                      email(emailController),
                      password(passwordController),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgotPassword()),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 14, top: 8),
                  child: Text(
                    'Forgot Password?',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorResource.darkGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CommonElevatedButton(
                text: StringResources.signIn,
                buttonColor: const Color(0xFF1A49A4),
                textColor: ColorResource.white,
                textSize: 16,
                margin: 10,
                onPressed: signInWithEmail,
              ),
              const SizedBox(height: 20),
              const Text(
                'Or connect using',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: ColorResource.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: SignInButton(
                          buttonType: ButtonType.google,
                          width: double.infinity,
                          buttonSize: ButtonSize.small,
                          btnColor: ColorResource.darkGreen,
                          btnText: 'Google',
                          btnTextColor: ColorResource.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: signInWithGoogle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: SignInButton(
                          buttonType: ButtonType.facebook,
                          width: double.infinity,
                          buttonSize: ButtonSize.small,
                          btnColor: ColorResource.darkGreen,
                          btnText: 'Facebook',
                          btnTextColor: ColorResource.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: signInWithFacebook,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                StringResources.accountRequest,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: ColorResource.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUp()),
                  (route) => false,
                ),
                child: const Text(
                  StringResources.signInOption,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19,
                    color: ColorResource.darkGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          isLoading ? const LoadingPage() : Container(),
        ],
      ),
    );
  }

  Future<void> signInWithEmail() async {
    setState(() {
      isLoading = true;
    });
    if (signInFormKey.currentState.validate()) {
      UserCredential userCredentials = await authService.verifyUser(
          context, emailController.text, passwordController.text);
      if (userCredentials != null) {
        Fluttertoast.showToast(
          msg: 'Hey, ${userCredentials.user.email}',
          backgroundColor: ColorResource.lightGreen,
          textColor: ColorResource.white,
        );
        appState.user = userCredentials.user;
        logs('Current user details : ${appState.user}');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Search()),
          (route) => false,
        );
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    UserCredential userCredential = await authService.signInWithGoogle(context);
    if (userCredential != null) {
      appState.user = userCredential.user;
      Fluttertoast.showToast(
        msg: 'Hey, ${appState.user.email}',
        backgroundColor: ColorResource.lightGreen,
        textColor: ColorResource.white,
      );
      logs('Current user details : ${appState.user}');
      logs('Google User : ${userCredential.additionalUserInfo.profile}');
      String token = await firebaseNotification.firebaseToken();
      UserModel userDetails = UserModel(
        email: userCredential.additionalUserInfo.profile['email'],
        lastName: userCredential.additionalUserInfo.profile['family_name'],
        firstName: userCredential.additionalUserInfo.profile['given_name'],
        image: userCredential.additionalUserInfo.profile['picture'],
        uid: userCredential.user.uid,
        token: token,
        type: 'Google',
      );
      await userService.createUser(userDetails);
      await setPrefBoolValue(isSocialLogin, true);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Search()),
        (route) => false,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> signInWithFacebook() async {
    setState(() {
      isLoading = true;
    });
    UserCredential facebookLoginData =
        await authService.signInWithFacebook(context);
    if (facebookLoginData != null) {
      appState.user = facebookLoginData.user;
      Fluttertoast.showToast(
        msg: 'Hey, ${appState.user.email}',
        backgroundColor: ColorResource.lightGreen,
        textColor: ColorResource.white,
      );
      logs('Current user details : ${appState.user}');
      logs('Facebook User : ${facebookLoginData.user}');
      String token = await firebaseNotification.firebaseToken();
      UserModel userDetails = UserModel(
        email: facebookLoginData.user.email,
        lastName: facebookLoginData.user.displayName.split(' ')[0].trim(),
        firstName: facebookLoginData.user.displayName.split(' ')[1].trim(),
        image: facebookLoginData.user.photoURL,
        uid: facebookLoginData.user.uid,
        token: token,
        type: 'Facebook',
      );
      await userService.createUser(userDetails);
      await setPrefBoolValue(isSocialLogin, true);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Search()),
        (route) => false,
      );
    }
    setState(() {
      isLoading = false;
    });
  }
}
