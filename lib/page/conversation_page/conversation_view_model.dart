// ignore_for_file: invalid_use_of_protected_member

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:user_auth/common/app/app_state.dart';
import 'package:user_auth/common/constant/string_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/model/chat_room_model.dart';
import 'package:user_auth/page/conversation_page/conversation.dart';
import 'package:user_auth/services/chatroom_service.dart';
import 'package:user_auth/services/firebase_messaging.dart';
import 'package:user_auth/services/notification_api.dart';

class ConversationViewModel {
  final ConversationState conversationState;
  FirebaseNotification firebaseNotification = FirebaseNotification();
  ChatRoomService chatRoomService = ChatRoomService();
  Reference reference = FirebaseStorage.instance.ref();
  String imageUrl;

  ConversationViewModel(this.conversationState) {
    firebaseNotification.sendNotification();
    firebaseNotification.configLocalNotification();
  }

  Future<void> uploadImageToServer(
      {@required String fileName, @required File file}) async {
    Reference referencePath =
        reference.child('Users/${appState.user.uid}/$fileName');
    UploadTask uploadTask = referencePath.putFile(file);
    if (uploadTask != null) {
      uploadTask.whenComplete(() async {
        imageUrl = await referencePath.getDownloadURL();
        logs('Image url --> $imageUrl');
        conversationState.isLoading = false;
        await sendMessageButton(isAttachment: true);
        conversationState.setState(() {});
      });
    }
  }

  sendMessageButton({bool isAttachment = false}) async {
    if (isAttachment || conversationState.messageController.text.isNotEmpty) {
      ChatRoomModel chatRoomModel = ChatRoomModel(
        message:
            isAttachment ? imageUrl : conversationState.messageController.text,
        receiver: conversationState.widget.receiver,
        sender: conversationState.widget.sender,
        time: DateTime.now().toIso8601String(),
        token: conversationState.widget.token,
        messageType: isAttachment
            ? MessageType.attachment.name
            : MessageType.message.name,
      );
      chatRoomService.addConversationMessage(
          conversationState.widget.chatRoomId,
          chatRoomModel,
          conversationState.context);
      if (conversationState.widget.token != null &&
          conversationState.widget.token.isNotEmpty) {
        sendNotification(
          isAttachment ? imageUrl : conversationState.messageController.text,
          conversationState.widget.sender,
          conversationState.widget.token,
        );
      }
      conversationState.messageController.clear();
    }
  }
}
