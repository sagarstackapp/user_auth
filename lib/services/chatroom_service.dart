import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_auth/common/method/methods.dart';

class ChatRoomService {
  final CollectionReference chatRoomCollection =
      FirebaseFirestore.instance.collection('chatRoom');

  createChatRoom(chatRoomModel, String chatRoom) async {
    try {
      await chatRoomCollection.doc(chatRoom).set(chatRoomModel);
    } catch (e) {
      logs('Catch error in Create ChatRoom : $e');
    }
  }

  addConversationMessage(String chatRoom, data) {
    try {
      chatRoomCollection.doc(chatRoom).collection('Chats').add(data);
    } catch (e) {
      logs('Catch error in Add Conversation Message : $e');
    }
  }

  getConversationMessage(String chatRoom) async {
    try {
      return chatRoomCollection
          .doc(chatRoom)
          .collection('Chats')
          .orderBy('Time')
          .snapshots();
    } catch (e) {
      logs('Catch error in Get Conversation Message : $e');
    }
  }
}
