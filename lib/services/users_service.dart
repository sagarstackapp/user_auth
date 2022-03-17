import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_auth/common/constant/string_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/model/user_model.dart';

class UserService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  //     ======================= Create user =======================     //
  Future<void> createUser(UserModel user, BuildContext context) async {
    try {
      await userCollection.doc(user.uid).set(user.userMap());
    } on FirebaseException catch (e) {
      logs('Catch error in Create User : ${e.message}');
      showMessage(context, e.message);
    }
  }

  //     ======================= Get all users =======================     //
  Future<List<UserModel>> getAllUsers(BuildContext context) async {
    try {
      List<UserModel> allUsers = [];
      QuerySnapshot querySnapshot = await userCollection.get();
      for (var element in querySnapshot.docs) {
        Map<String, dynamic> map = element.data() as Map<String, dynamic>;
        UserModel categoryModel = UserModel.fromMap(map);
        allUsers.add(categoryModel);
      }
      return allUsers;
    } on FirebaseException catch (e) {
      logs('Catch error in Get All Users : ${e.message}');
      showMessage(context, e.message);
      return null;
    }
  }

  //     ======================= Get current user =======================     //
  Future<UserModel> getCurrentDataUser(String uid, BuildContext context) async {
    try {
      DocumentSnapshot doc = await userCollection.doc(uid).get();
      return UserModel.fromMap(doc.data());
    } on FirebaseException catch (e) {
      logs('Catch error in Get Current User : ${e.message}');
      showMessage(context, e.message);
      return null;
    }
  }

  //     ======================= Delete token =======================     //
  Future<void> deleteToken(BuildContext context) async {
    try {
      await userCollection
          .doc(appState.user.uid)
          .update({'token': FieldValue.delete()});
    } on FirebaseException catch (e) {
      logs('Catch error in Update Token : ${e.message}');
      showMessage(context, e.message);
    }
  }
}
