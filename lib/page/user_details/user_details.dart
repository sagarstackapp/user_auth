import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/constant/image_res.dart';
import 'package:user_auth/common/constant/string_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/common/widget/widget.dart';
import 'package:user_auth/page/jokes/jokes_category.dart';
import 'package:user_auth/page/user_details/user_details_view_model.dart';
import 'package:user_auth/services/auth_service.dart';

class UserDetails extends StatefulWidget {
  @override
  UserDetailsState createState() => UserDetailsState();
}

class UserDetailsState extends State<UserDetails> {
  UserDetailsViewModel userDetailsViewModel;

  AuthService authService = AuthService();
  GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    userDetailsViewModel ?? (userDetailsViewModel = UserDetailsViewModel(this));
    print(runtimeType);
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        appBar: topMenuBar(context,
            '${userDetailsViewModel.userModel == null ? ' ' : '${userDetailsViewModel.userModel.fname}\'s ${StringResources.Title}'}'),
        body: userDetailsViewModel.userModel == null
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(ColorResource.Orange),
                  strokeWidth: 5,
                  backgroundColor: ColorResource.White,
                ),
              )
            : userDetails(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_alert),
          onPressed: goToJokerCategory,
        ),
      ),
    );
  }

  goToSignIn() {
    goSignIn(context);
  }

  Widget userDetails() {
    return SizedBox(
      height: double.infinity,
      child: Card(
        elevation: 20,
        shadowColor: ColorResource.White,
        color: ColorResource.Grey,
        child: ListView(
          shrinkWrap: true,
          children: [
            CircleAvatar(
              backgroundColor: ColorResource.White,
              radius: 70,
              child: CircleAvatar(
                backgroundImage: userDetailsViewModel.userModel.image == null
                    ? AssetImage(ImageResources.Avatar)
                    : NetworkImage(userDetailsViewModel.userModel.image),
                radius: 60,
              ), //CircleAvatar
            ),
            SizedBox(height: 20),
            Text(
              '${userDetailsViewModel.userModel.email}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: ColorResource.Black,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${userDetailsViewModel.userModel.fname} ${userDetailsViewModel.userModel.lname}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: ColorResource.White,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            elevatedButton('LogOut', () {
              print('Log Out');
              authService.userSignOut();
              goToSignIn();
            }),
          ],
        ),
      ),
    );
  }

  goToJokerCategory() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => JokeCategory()));
    setState(() {});
  }
}
