import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_auth/common/app/app_state.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/constant/image_res.dart';
import 'package:user_auth/common/constant/string_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/common/widget/common_image_assets.dart';
import 'package:user_auth/common/widget/common_loader.dart';
import 'package:user_auth/common/widget/elevated_button.dart';
import 'package:user_auth/common/widget/widget.dart';
import 'package:user_auth/model/user_model.dart';
import 'package:user_auth/page/sign_in/sign_in.dart';
import 'package:user_auth/services/auth_service.dart';
import 'package:user_auth/services/firebase_messaging.dart';
import 'package:user_auth/services/users_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final signUpFormKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  AuthService authService = AuthService();
  UserService userService = UserService();
  FirebaseNotification firebaseNotification = FirebaseNotification();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: ColorResource.white,
        body: Stack(
          children: [
            ListView(
              children: [
                const Text(
                  'Register User',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  child: const CommonImageAsset(image: ImageResources.login),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Form(
                    key: signUpFormKey,
                    child: Column(
                      children: [
                        name(firstNameController, 'Enter first name'),
                        name(lastNameController, 'Enter last name'),
                        email(emailController),
                        password(passwordController),
                        confirmPassword(
                            passwordController, confirmPasswordController),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AbsorbPointer(
                  child: CommonElevatedButton(
                    text: StringResources.register,
                    buttonColor: const Color(0xFF1A49A4),
                    textColor: ColorResource.white,
                    textSize: 16,
                    margin: 10,
                    onPressed: registerUser,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  StringResources.logInRequest,
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
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()),
                    (route) => false,
                  ),
                  child: const Text(
                    StringResources.signUpOption,
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
      ),
    );
  }

  registerUser() async {
    if (signUpFormKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      signUpFormKey.currentState.save();
      UserCredential userCredential = await authService.createUser(
          emailController.text, passwordController.text);
      if (userCredential != null) {
        String token = await firebaseNotification.firebaseToken(context);
        logs('Token Value --> $token');
        UserModel userDetails = UserModel(
          uid: userCredential.user.uid,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: userCredential.user.email,
          token: token ?? '',
          type: LogInType.firebase.name,
        );
        logs('UserDetails --> ${userDetails.userMap()}');
        await userService.createUser(userDetails, context);
        Fluttertoast.showToast(
          msg: '${firstNameController.text}\'s account created successfully..!',
          backgroundColor: ColorResource.orange,
          textColor: ColorResource.white,
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
          (route) => false,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'You already registered, Please Sign In.!',
          backgroundColor: ColorResource.red,
          textColor: ColorResource.white,
        );
      }
    }
    setState(() {
      isLoading = false;
    });
  }
}
