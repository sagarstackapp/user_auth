import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_auth/common/app/app_state.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/common/widget/common_app_bar.dart';
import 'package:user_auth/common/widget/common_image_assets.dart';
import 'package:user_auth/common/widget/common_loader.dart';
import 'package:user_auth/common/widget/widget.dart';
import 'package:user_auth/page/conversation_page/conversation_view_model.dart';
import 'package:user_auth/services/chatroom_service.dart';

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
  final TextEditingController messageController = TextEditingController();
  ChatRoomService chatRoomService = ChatRoomService();
  ConversationViewModel conversationViewModel;
  final ImagePicker imagePicker = ImagePicker();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    conversationViewModel ??
        (conversationViewModel = ConversationViewModel(this));
    return Scaffold(
      appBar: CommonAppBar(title: widget.receiver, showDrawer: false),
      body: Stack(
        children: [
          Container(
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
                          return const Center(
                              child: Text('Something went wrong'));
                        } else if (snapshot.hasData) {
                          return snapshot.data.docs.isEmpty
                              ? Center(
                                  child: Text(
                                    'Let\'s Start chat with ${widget.receiver}',
                                    style: const TextStyle(
                                      color: ColorResource.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    return displayMessage(
                                      snapshot.data.docs[index]['message'],
                                      snapshot.data.docs[index]['messageType'],
                                      snapshot.data.docs[index]['sender'] ==
                                          widget.sender,
                                    );
                                  },
                                );
                        } else {
                          return const Text(
                            'No Messages',
                            style: TextStyle(
                              color: ColorResource.white,
                              fontSize: 20,
                            ),
                          );
                        }
                      } else {
                        return Center(
                          child: Text(
                            snapshot.connectionState.name,
                            style: const TextStyle(
                              color: ColorResource.white,
                              fontSize: 20,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                sendRow(),
              ],
            ),
          ),
          isLoading ? const LoadingPage() : Container(),
        ],
      ),
    );
  }

  Container sendRow() {
    return Container(
      color: ColorResource.darkGreen,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => getImage(),
            child: const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Icon(Icons.image, color: ColorResource.white),
            ),
          ),
          Flexible(child: typeMessageField(messageController)),
          chatIcon(
            8.0,
            Icons.send_outlined,
            conversationViewModel.sendMessageButton,
          ),
        ],
      ),
    );
  }

  Container displayMessage(String message, String messageType, bool sender) {
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
          child: messageType == MessageType.attachment.name
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CommonImageAsset(
                    isWebImage: true,
                    image: message,
                    webHeight: 210,
                    webFit: BoxFit.cover,
                  ),
                )
              : Text(
                  message,
                  style: const TextStyle(fontSize: 14),
                ),
        ),
      ),
    );
  }

  Future<void> getImage() async {
    XFile galleryImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if (galleryImage != null) {
      File selectedFile = File(galleryImage.path);
      String fileName = galleryImage.name;
      setState(() {
        isLoading = true;
      });
      conversationViewModel.uploadImageToServer(
          fileName: fileName, file: selectedFile);
    }
  }
}
