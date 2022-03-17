import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/constant/image_res.dart';
import 'package:user_auth/common/constant/string_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/common/widget/common_app_bar.dart';
import 'package:user_auth/common/widget/widget.dart';
import 'package:user_auth/page/jokes/jokes_category/jokes_category.dart';
import 'package:user_auth/page/sign_in/sign_in.dart';
import 'package:user_auth/page/user_details/user_details_view_model.dart';
import 'package:user_auth/services/auth_service.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key key}) : super(key: key);

  @override
  UserDetailsState createState() => UserDetailsState();
}

class UserDetailsState extends State<UserDetails> {
  UserDetailsViewModel userDetailsViewModel;

  AuthService authService = AuthService();
  GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    userDetailsViewModel ?? (userDetailsViewModel = UserDetailsViewModel(this));
    logs('Current screen --> $runtimeType');
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        appBar: CommonAppBar(
            title: userDetailsViewModel.userModel == null
                ? ' '
                : '${userDetailsViewModel.userModel.firstName}\'s ${StringResources.title}'),
        body: userDetailsViewModel.userModel == null
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(ColorResource.orange),
                  strokeWidth: 5,
                  backgroundColor: ColorResource.white,
                ),
              )
            : userDetails(),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.celebration_outlined),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const JokeCategory()),
            );
          },
        ),
      ),
    );
  }

  Widget userDetails() {
    return SizedBox(
      height: double.infinity,
      child: Card(
        elevation: 20,
        shadowColor: ColorResource.white,
        color: ColorResource.grey,
        child: ListView(
          shrinkWrap: true,
          children: [
            CircleAvatar(
              backgroundColor: ColorResource.white,
              radius: 70,
              child: CircleAvatar(
                backgroundImage: userDetailsViewModel.userModel.image == null
                    ? const AssetImage(ImageResources.avatar)
                    : NetworkImage(userDetailsViewModel.userModel.image),
                radius: 60,
              ), //CircleAvatar
            ),
            const SizedBox(height: 20),
            Text(
              userDetailsViewModel.userModel.email,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: ColorResource.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${userDetailsViewModel.userModel.firstName} ${userDetailsViewModel.userModel.lastName}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                color: ColorResource.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            elevatedButton(
              'LogOut',
              () => logOut,
            ),
          ],
        ),
      ),
    );
  }

  logOut() {
    authService.userSignOut(context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (route) => false,
    );
  }
}
