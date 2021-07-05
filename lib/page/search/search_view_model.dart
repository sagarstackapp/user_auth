import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_auth/model/user_model.dart';
import 'package:user_auth/services/users_service.dart';

import 'search_page.dart';

class SearchViewModel {
  var uid = FirebaseAuth.instance.currentUser.uid;

  SearchState searchState;
  UserModel userModel;
  UserService userService = UserService();

  SearchViewModel(this.searchState) {
    getUserDetails(uid);
  }

  Future getUserDetails(String uid) async {
    var value = await userService.getCurrentDataUser(uid);
    if (value == null) {
      print('View Model data is null');
    } else {
      userModel = value;
    }

    if (searchState.mounted) {
      // ignore: invalid_use_of_protected_member
      searchState.setState(() {});
    }
  }
}
