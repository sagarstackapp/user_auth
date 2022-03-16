import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/model/chat_room_model.dart';

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

  addConversationMessage(String chatRoom, ChatRoomModel data) {
    try {
      chatRoomCollection.doc(chatRoom).collection('Chats').add(data.toJson());
    } catch (e) {
      logs('Catch error in Add Conversation Message : $e');
    }
  }

  Future<List<ChatRoomModel>> getConversationMessage(String chatRoom) async {
    try {
      List<ChatRoomModel> allChats = [];
      QuerySnapshot querySnapshot = await chatRoomCollection
          .doc(chatRoom)
          .collection('Chats')
          .orderBy('time')
          .get();
      for (var element in querySnapshot.docs) {
        Map<String, dynamic> map = element.data() as Map<String, dynamic>;
        ChatRoomModel chatRoomModel = ChatRoomModel.fromJson(map);
        allChats.add(chatRoomModel);
      }
      return allChats;
    } catch (e) {
      logs('Catch error in Get Conversation Message : $e');
      return null;
    }
  }
}
