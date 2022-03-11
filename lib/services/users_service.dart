import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/model/user_model.dart';

class UserService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future createUser(UserModel user) async {
    try {
      await userCollection.doc(user.uid).set(user.userMap());
    } catch (e) {
      logs('Catch error in Create User : $e');
    }
  }

  Future<UserModel> getCurrentDataUser(String uid) async {
    try {
      DocumentSnapshot doc = await userCollection.doc(uid).get();
      return UserModel.fromMap(doc.data());
    } catch (e) {
      logs('Catch error in Get Current User : $e');
      return null;
    }
  }

  Future updateToken(String uid, String token) async {
    try {
      var fields = await userCollection.doc(uid).update({'token': token});
      return fields;
    } on Exception catch (e) {
      logs('Catch error in Update Token : $e');
      return null;
    }
  }

  //     ======================= Update User Data in Users Table =======================     //
  Future purchaseId(String userId, int productId) async {
    try {
      await userCollection.doc(userId).update({'pid': productId});
    } catch (e) {
      logs('Catch error in Purchase Id : $e');
    }
  }
}
