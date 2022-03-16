import 'package:flutter/material.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/constant/string_res.dart';
import 'package:user_auth/common/widget/common_app_bar.dart';
import 'package:user_auth/common/widget/common_image_assets.dart';
import 'package:user_auth/common/widget/common_loader.dart';
import 'package:user_auth/common/widget/widget.dart';
import 'package:user_auth/model/user_model.dart';
import 'package:user_auth/page/conversation_page/conversation.dart';
import 'package:user_auth/page/jokes/jokes_category.dart';
import 'package:user_auth/page/search/search_view_model.dart';
import 'package:user_auth/page/sign_in/sign_in.dart';
import 'package:user_auth/services/auth_service.dart';
import 'package:user_auth/services/users_service.dart';

class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  AuthService authService = AuthService();
  UserService userService = UserService();
  SearchViewModel searchViewModel;

  @override
  Widget build(BuildContext context) {
    searchViewModel ?? (searchViewModel = SearchViewModel(this));
    return Scaffold(
      appBar: CommonAppBar(
        title: searchViewModel.userModel == null
            ? ' '
            : '${searchViewModel.userModel.firstName} ${searchViewModel.userModel.lastName}\'s Chat',
        isHome: true,
      ),
      body: usersList(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          floatingButton(
            Icons.doorbell,
            'Jokes Category',
            () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const JokeCategory())),
          ),
          const SizedBox(height: 10),
          floatingButton(
            Icons.logout,
            'LogOut',
            () => logOut(),
          ),
        ],
      ),
    );
  }

  FutureBuilder usersList() {
    return FutureBuilder<List<UserModel>>(
      future: userService.getAllUsers(),
      builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingPage());
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else if (snapshot.hasData) {
            return snapshot.data.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 200),
                      child: Text('No user available for now'),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      if (appState.user.uid == snapshot.data[index].uid) {
                        return const SizedBox();
                      }
                      return GestureDetector(
                        onTap: () {
                          String roomId = searchViewModel
                                      .userModel.uid.hashCode <=
                                  snapshot.data[index].uid.hashCode
                              ? '${searchViewModel.userModel.uid}_${snapshot.data[index].uid}'
                              : '${snapshot.data[index].uid}_${searchViewModel.userModel.uid}';
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Conversation(
                                sender: appState.user.displayName,
                                receiver:
                                    '${snapshot.data[index].firstName} ${snapshot.data[index].lastName}',
                                token: snapshot.data[index].token,
                                chatRoomId: roomId,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          elevation: 10,
                          shadowColor: ColorResource.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            minLeadingWidth: 0,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CommonImageAsset(
                                image: snapshot.data[index].image,
                                isWebImage: true,
                                webHeight: 50,
                                webWidth: 50,
                              ),
                            ),
                            title: Text(
                              '${snapshot.data[index].firstName ?? ''} ${snapshot.data[index].lastName ?? ''}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      if (appState.user.uid == snapshot.data[index].uid) {
                        return const SizedBox();
                      }
                      return const Divider(
                        height: 2,
                        color: ColorResource.white,
                      );
                    },
                  );
          } else {
            return const Text('No Users Found');
          }
        } else {
          return Center(child: Text(snapshot.connectionState.name));
        }
      },
    );
  }

  void logOut() {
    authService.userSignOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignIn()),
      (route) => false,
    );
  }
}
