import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/common/widget/searchtile.dart';
import 'package:user_auth/common/widget/widget.dart';
import 'package:user_auth/page/conversation_page/conversation.dart';
import 'package:user_auth/page/search/search_view_model.dart';
import 'package:user_auth/services/auth_service.dart';
import 'package:user_auth/services/chatroom_service.dart';
import 'package:user_auth/services/firebase_messaging.dart';
import 'package:user_auth/services/users_service.dart';

class Search extends StatefulWidget {
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  TextEditingController firstnameController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  AuthService authService = AuthService();
  UserService userService = UserService();
  FirebaseNotification firebaseNotification = FirebaseNotification();
  ChatRoomService chatRoomService = ChatRoomService();
  SearchViewModel searchViewModel;

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    searchViewModel ?? (searchViewModel = SearchViewModel(this));
    return Scaffold(
      appBar: topMenuBar(context,
          '${searchViewModel.userModel == null ? ' ' : '${searchViewModel.userModel.fname} ${searchViewModel.userModel.lname}\'s Chat Search'}'),
      body: searchingList(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          floatingButton(Icons.doorbell, () {
            goJokeCategory(context);
          }, 'Jokes Category'),
          SizedBox(height: 10),
          floatingButton(Icons.logout, () {
            authService.userSignOut();
            goSignIn(context);
          }, 'LogOut'),
        ],
      ),
    );
  }

  Widget searchingList() {
    return StreamBuilder(
      stream: userCollection.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return showAPILoader(context);
        }
        return ListView.separated(
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          separatorBuilder: (context, index) {
            return Divider(
              height: 2,
              color: ColorResource.White,
            );
          },
          itemBuilder: (context, index) {
            return searchViewModel.userModel.uid ==
                    snapshot.data.docs[index]['uid']
                ? Container()
                : SearchTile(
                    title: snapshot.data.docs[index]['fname'],
                    email: snapshot.data.docs[index]['email'],
                    onPressed: () async {
                      var sender = searchViewModel.userModel.uid;
                      var receiver = snapshot.data.docs[index]['uid'];
                      var receiverFname = snapshot.data.docs[index]['fname'];
                      var senderFname = searchViewModel.userModel.fname;
                      var tokens = searchViewModel.userModel.token;
                      var token = snapshot.data.docs[index]['token'];
                      print(' Sender ID : $sender');
                      print(' Receiver ID : $receiver');
                      print(' Sender name : $senderFname');
                      print(' Receiver name : $receiverFname');
                      print('Sender : $token');
                      print('Receiver : $tokens');
                      String roomId = sender.hashCode <= receiver.hashCode
                          ? '${sender}_$receiver'
                          : '${receiver}_$sender';
                      print(' Room Id : $roomId');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Conversation(
                            chatRoomId: roomId,
                            sender: senderFname,
                            receiver: receiverFname,
                            token: token,
                          ),
                        ),
                      );
                    },
                  );
          },
        );
      },
    );
  }
}
