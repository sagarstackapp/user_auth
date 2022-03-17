// ignore_for_file: invalid_use_of_protected_member

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_auth/common/constant/string_res.dart';
import 'package:user_auth/model/user_model.dart';
import 'package:user_auth/page/search/search_page.dart';
import 'package:user_auth/services/users_service.dart';

class SearchViewModel {
  SearchState searchState;
  UserModel userModel;
  UserService userService = UserService();

  SearchViewModel(this.searchState) {
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    User user = FirebaseAuth.instance.currentUser;
    log('User --> $user');
    appState.user = user;
    userModel = await userService.getCurrentDataUser(
        appState.user.uid, searchState.context);
    searchState.setState(() {});
  }
}
