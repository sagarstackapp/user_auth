import 'package:flutter/material.dart';
import 'package:user_auth/common/constant/color_res.dart';
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
    return Scaffold(
      appBar: CommonAppBar(title: widget.receiver),
      body: Column(
        children: [
          messageChatScreen(),
          sendRow(),
        ],
      ),
    );
  }

  Expanded messageChatScreen() {
    return Expanded(
      child: FutureBuilder<List<ChatRoomModel>>(
        future:
            chatRoomService.getConversationMessage(widget.chatRoomId, context),
        builder: (BuildContext context,
            AsyncSnapshot<List<ChatRoomModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(color: Colors.transparent);
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else if (snapshot.hasData) {
              return snapshot.data.isEmpty
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
    );
  }

  Row sendRow() {
    return Row(
      children: [
        Flexible(child: typeMessageField(messageController)),
        chatIcon(8.0, Icons.send_outlined, sendMessageButton),
      ],
    );
  }

  Align displayMessage(String message, bool sender) {
    return Align(
      alignment: sender ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: sender ? Colors.white10 : Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              message,
              style: const TextStyle(color: ColorResource.white),
            ),
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
      sendNotification(messageController.text, widget.sender, widget.token);
      messageController.clear();
      setState(() {});
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
