import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/model/chat_room_model.dart';

class ChatRoomService {
  final CollectionReference chatRoomCollection =
      FirebaseFirestore.instance.collection('ChatRoom');

  //     ======================= Create chat room =======================     //
  createChatRoom(chatRoomModel, String chatRoom, BuildContext context) async {
    try {
      await chatRoomCollection.doc(chatRoom).set(chatRoomModel);
    } on FirebaseException catch (e) {
      logs('Catch error in Create ChatRoom : ${e.message}');
      showMessage(context, e.message);
    }
  }

  //     ======================= Add messages =======================     //
  addConversationMessage(
      String chatRoom, ChatRoomModel data, BuildContext context) {
    try {
      chatRoomCollection.doc(chatRoom).collection('Chats').add(data.toJson());
    } on FirebaseException catch (e) {
      logs('Catch error in Add Conversation Message : ${e.message}');
      showMessage(context, e.message);
    }
  }

  //     ======================= Get messages =======================     //
  Stream<QuerySnapshot> getConversationMessage(
      String chatRoom, BuildContext context) {
    try {
      Stream<QuerySnapshot> querySnapshot = chatRoomCollection
          .doc(chatRoom)
          .collection('Chats')
          .orderBy('time')
          .snapshots();
      return querySnapshot;
    } on FirebaseException catch (e) {
      logs('Catch error in Get Conversation Message : ${e.message}');
      showMessage(context, e.message);
      return null;
    }
  }
}
