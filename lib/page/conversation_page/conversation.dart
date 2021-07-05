import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/common/widget/widget.dart';
import 'package:user_auth/services/chatroom_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:user_auth/services/firebase_messaging.dart';
import 'package:user_auth/services/notification_api.dart';

class Conversation extends StatefulWidget {
  final String chatRoomId;
  final String sender;
  final String receiver;
  final String token;

  Conversation({this.chatRoomId, this.sender, this.receiver, this.token});

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
    chatRoomService
        .getConversationMessage('${widget.chatRoomId}')
        .then((value) {
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
      appBar: topMenuBar(context, '${widget.receiver}\'s Chat conversation'),
      body: Column(
        children: [
          messageChatScreen(),
          sendRow(),
        ],
      ),
    );
  }

  Widget messageChatScreen() {
    print('Sender ChatStream  : $senderChatStream');
    return Expanded(
      child: senderChatStream == null
          ? Container(child: Text('Value coming null'))
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
            child: message.length <= 0
                ? CachedNetworkImage(
                    imageUrl: src,
                    placeholder: loader,
                  )
                : Text(
                    message,
                    style: TextStyle(color: ColorResource.White),
                  ),
          ),
        ),
      ),
    );
  }

  galleryImage() async {
    try {
      PickedFile images = await picker.getImage(
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
          await uploadTask
              .whenComplete(() => print('Uploading Task Completed'));
        } catch (e) {
          print('Catch error in Upload Image : $e');
        }

        print('Before Image URL : $returnURL');

        try {
          reference.getDownloadURL().then((value) => returnURL = value);
        } catch (e) {
          print('Catch error in Download Image : $e');
        }
        print('After Image URL : $returnURL');
        hideLoader(context);
        return returnURL;
      } else {
        Fluttertoast.showToast(
          msg: 'Please, Select image first',
          backgroundColor: ColorResource.Red,
          textColor: ColorResource.White,
        );
      }
    } catch (e) {
      print('Catch error in Gallery Image : $e');
    }
  }

  sendMessageButton() async {
    // var token = await firebaseNotification.firebaseToken();
    // print('Token Value : $token');
    print('Received Chat Id : ${widget.chatRoomId}');
    print('Return Url : $returnURL');
    Map<String, String> chatRoomModel = {
      'Message': '${messageController.text}',
      'Image': '$returnURL',
      'Sender': '${widget.sender}',
      'Receiver': '${widget.receiver}',
      'Time': '${DateTime.now().toString().split(' ')[1]}',
      'token': widget.token,
    };
    if (messageController.text.length == 0 && returnURL == null) {
      Fluttertoast.showToast(
        msg: 'Please, Type message first',
        textColor: ColorResource.White,
        backgroundColor: ColorResource.Red,
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
          Center(
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
