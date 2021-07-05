import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_auth/model/user_model.dart';
import 'package:user_auth/page/user_details/user_details.dart';
import 'package:user_auth/services/users_service.dart';

class UserDetailsViewModel {
  var uid = FirebaseAuth.instance.currentUser.uid;

  UserDetailsState userDetailsState;
  UserModel userModel;
  UserService userService = UserService();

  UserDetailsViewModel(this.userDetailsState) {
    getUserDetails(uid);
  }

  Future getUserDetails(String uid) async {
    var value = await userService.getCurrentDataUser(uid);
    if (value == null) {
      print('View Model data is null');
    } else {
      userModel = value;
    }

    if (userDetailsState.mounted) {
      // ignore: invalid_use_of_protected_member
      userDetailsState.setState(() {});
    }
  }
}
