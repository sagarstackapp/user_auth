import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/common/widget/common_app_bar.dart';
import 'package:user_auth/common/widget/widget.dart';
import 'package:user_auth/services/chatroom_service.dart';
import 'package:user_auth/services/firebase_messaging.dart';
import 'package:user_auth/services/notification_api.dart';

class Conversation extends StatefulWidget {
  final String chatRoomId;
  final String sender;
  final String receiver;
  final String token;

  const Conversation(
      {Key key, this.chatRoomId, this.sender, this.receiver, this.token})
      : super(key: key);

  @override
  ConversationState createState() => ConversationState();
}

Stream senderChatStream;
String returnURL;

class ConversationState extends State<Conversation> {
  TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  ChatRoomService chatRoomService = ChatRoomService();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FirebaseNotification firebaseNotification = FirebaseNotification();
  PickedFile image;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    chatRoomService.getConversationMessage(widget.chatRoomId).then((value) {
      setState(() {
        senderChatStream = value;
      });
    });
    firebaseNotification.sendNotification();
    firebaseNotification.configLocalNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: '${widget.receiver}\'s Chat conversation'),
      body: Column(
        children: [
          messageChatScreen(),
          sendRow(),
        ],
      ),
    );
  }

  Widget messageChatScreen() {
    logs('Sender ChatStream  : $senderChatStream');
    return Expanded(
      child: senderChatStream == null
          ? const Text('Value coming null')
          : StreamBuilder(
              stream: senderChatStream,
              builder: (context, snapshots) {
                return !snapshots.hasData
                    ? showAPILoader(context)
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshots.data.docs.length,
                        itemBuilder: (context, index) {
                          return (!snapshots.hasData)
                              ? Center(child: showAPILoader(context))
                              : displayMessage(
                                  '${snapshots.data.docs[index]['Message']}',
                                  '${snapshots.data.docs[index]['Image']}',
                                  snapshots.data.docs[index]['Sender'] ==
                                      widget.sender,
                                );
                        },
                      );
              },
            ),
    );
  }

  Widget sendRow() {
    return Row(
      children: <Widget>[
        chatIcon(1.0, Icons.image, galleryImage),
        // chatIcon(1.0, Icons.face, null),
        Flexible(
          child: typeMessageField(messageController),
        ),
        chatIcon(8.0, Icons.send_outlined, sendMessageButton),
      ],
    );
  }

  Widget displayMessage(String message, String src, bool sender) {
    return Align(
      alignment: sender ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          width: MediaQuery.of(context).size.width / 2.5,
          decoration: BoxDecoration(
            color: sender ? Colors.white10 : Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: message.isEmpty
                ? CachedNetworkImage(
                    imageUrl: src,
                    placeholder: loader,
                  )
                : Text(
                    message,
                    style: const TextStyle(color: ColorResource.white),
                  ),
          ),
        ),
      ),
    );
  }

  galleryImage() async {
    try {
      XFile images = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      if (images != null) {
        firebase_storage.Reference reference = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('ChatImage/')
            .child(images.path);
        firebase_storage.UploadTask uploadTask =
            reference.putFile(File(images.path));
        showLoader(context);
        try {
          await uploadTask.whenComplete(() => logs('Uploading Task Completed'));
        } catch (e) {
          logs('Catch error in Upload Image : $e');
        }

        logs('Before Image URL : $returnURL');

        try {
          reference.getDownloadURL().then((value) => returnURL = value);
        } catch (e) {
          logs('Catch error in Download Image : $e');
        }
        logs('After Image URL : $returnURL');
        return returnURL;
      } else {
        Fluttertoast.showToast(
          msg: 'Please, Select image first',
          backgroundColor: ColorResource.red,
          textColor: ColorResource.white,
        );
      }
    } catch (e) {
      logs('Catch error in Gallery Image : $e');
    }
  }

  sendMessageButton() async {
    // var token = await firebaseNotification.firebaseToken();
    // logs('Token Value : $token');
    logs('Received Chat Id : ${widget.chatRoomId}');
    logs('Return Url : $returnURL');
    Map<String, String> chatRoomModel = {
      'Message': messageController.text,
      'Image': returnURL,
      'Sender': widget.sender,
      'Receiver': widget.receiver,
      'Time': DateTime.now().toString().split(' ')[1],
      'token': widget.token,
    };
    if (messageController.text.isEmpty && returnURL == null) {
      Fluttertoast.showToast(
        msg: 'Please, Type message first',
        textColor: ColorResource.white,
        backgroundColor: ColorResource.red,
      );
    } else {
      setState(() {});
      chatRoomService.addConversationMessage(widget.chatRoomId, chatRoomModel);
      sendNotification(messageController.text, widget.sender, widget.token);
      messageController.text = '';
    }
  }

  Widget loader(BuildContext context, String url) {
    return Center(
      child: Stack(
        children: [
          Container(
            color: Colors.transparent,
          ),
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
