import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/common/widget/common_app_bar.dart';
import 'package:user_auth/common/widget/widget.dart';
import 'package:user_auth/model/chat_room_model.dart';
import 'package:user_auth/services/chatroom_service.dart';
import 'package:user_auth/services/firebase_messaging.dart';
import 'package:user_auth/services/notification_api.dart';

class Conversation extends StatefulWidget {
  final String chatRoomId;
  final String sender;
  final String receiver;
  final String token;

  const Conversation({
    Key key,
    @required this.chatRoomId,
    @required this.sender,
    @required this.receiver,
    @required this.token,
  }) : super(key: key);

  @override
  ConversationState createState() => ConversationState();
}

class ConversationState extends State<Conversation> {
  TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  ChatRoomService chatRoomService = ChatRoomService();
  FirebaseNotification firebaseNotification = FirebaseNotification();

  @override
  void initState() {
    firebaseNotification.sendNotification();
    firebaseNotification.configLocalNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return Scaffold(
      appBar: CommonAppBar(title: widget.receiver),
      body: Container(
        color: ColorResource.white.withOpacity(0.1),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: chatRoomService.getConversationMessage(
                    widget.chatRoomId, context),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(color: Colors.transparent);
                  } else if (snapshot.connectionState ==
                          ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong'));
                    } else if (snapshot.hasData) {
                      for (var element in snapshot.data.docs) {
                        ChatRoomModel chatRoomModel =
                            ChatRoomModel.fromJson(snapshot.data.docs);
                      }
                      return snapshot.data.docs.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 200),
                                child: Text('No message available for now'),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return displayMessage(
                                  snapshot.data[index].message,
                                  snapshot.data[index].sender == widget.sender,
                                );
                              },
                            );
                    } else {
                      return const Text('No Messages');
                    }
                  } else {
                    return Center(child: Text(snapshot.connectionState.name));
                  }
                },
              ),
            ),
            sendRow(),
          ],
        ),
      ),
    );
  }

  Container sendRow() {
    return Container(
      color: ColorResource.darkGreen,
      child: Row(
        children: [
          Flexible(child: typeMessageField(messageController)),
          chatIcon(8.0, Icons.send_outlined, sendMessageButton),
        ],
      ),
    );
  }

  Container displayMessage(String message, bool sender) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Align(
        alignment: sender ? Alignment.bottomRight : Alignment.bottomLeft,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: sender ? Colors.grey.shade200 : Colors.blue[200],
          ),
          child: Text(
            message,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  sendMessageButton() async {
    if (messageController.text.isNotEmpty) {
      ChatRoomModel chatRoomModel = ChatRoomModel(
        message: messageController.text,
        receiver: widget.receiver,
        sender: widget.sender,
        time: DateTime.now().toIso8601String(),
        token: widget.token,
      );
      chatRoomService.addConversationMessage(
          widget.chatRoomId, chatRoomModel, context);
      if (widget.token != null && widget.token.isNotEmpty) {
        sendNotification(messageController.text, widget.sender, widget.token);
      }
      messageController.clear();
      // setState(() {});
    }
  }

  Widget loader(BuildContext context, String url) {
    return Center(
      child: Stack(
        children: [
          Container(color: Colors.transparent),
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.orange),
              strokeWidth: 2,
              backgroundColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
