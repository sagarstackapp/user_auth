// ignore_for_file: invalid_use_of_protected_member

import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_auth/common/constant/string_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/model/user_model.dart';
import 'package:user_auth/page/user_details/user_details.dart';
import 'package:user_auth/services/users_service.dart';

class UserDetailsViewModel {
  var uid = FirebaseAuth.instance.currentUser.uid;

  UserDetailsState userDetailsState;
  UserModel userModel;
  UserService userService = UserService();

  UserDetailsViewModel(this.userDetailsState) {
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    User user = FirebaseAuth.instance.currentUser;
    logs('User --> $user');
    appState.user = user;
    userModel = await userService.getCurrentDataUser(
        appState.user.uid, userDetailsState.context);
    userDetailsState.setState(() {});
  }
}
