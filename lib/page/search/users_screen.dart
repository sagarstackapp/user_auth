import 'package:flutter/material.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/constant/string_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/common/widget/common_app_bar.dart';
import 'package:user_auth/common/widget/common_drawer.dart';
import 'package:user_auth/common/widget/common_image_assets.dart';
import 'package:user_auth/common/widget/common_loader.dart';
import 'package:user_auth/model/user_model.dart';
import 'package:user_auth/page/conversation_page/conversation.dart';
import 'package:user_auth/page/search/users_screen_view_model.dart';
import 'package:user_auth/page/sign_in/sign_in.dart';
import 'package:user_auth/services/auth_service.dart';
import 'package:user_auth/services/users_service.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key key}) : super(key: key);

  @override
  UsersScreenState createState() => UsersScreenState();
}

class UsersScreenState extends State<UsersScreen> {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  AuthService authService = AuthService();
  UserService userService = UserService();
  UsersScreenViewModel usersScreenViewModel;

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    usersScreenViewModel ?? (usersScreenViewModel = UsersScreenViewModel(this));
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: drawerKey,
        endDrawerEnableOpenDragGesture: false,
        appBar: CommonAppBar(
          title: usersScreenViewModel.userModel == null
              ? ''
              : '${usersScreenViewModel.userModel.firstName.toCapitalized()} ${usersScreenViewModel.userModel.lastName.toCapitalized()}\'s Chat',
          isHome: true,
          onDrawerTap: () => drawerKey.currentState.openEndDrawer(),
        ),
        endDrawer: CommonDrawer(drawerKey: drawerKey, isChatScreen: true),
        body: usersList(),
      ),
    );
  }

  FutureBuilder usersList() {
    return FutureBuilder<List<UserModel>>(
      future: userService.getAllUsers(context),
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
                : ListView(
                    primary: true,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 14, bottom: 10, top: 16),
                        child: Text(
                          'Users',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: ColorResource.white,
                          ),
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          if (appState.user.uid == snapshot.data[index].uid) {
                            return const SizedBox();
                          }
                          return GestureDetector(
                            onTap: () {
                              String roomId = usersScreenViewModel
                                          .userModel.uid.hashCode <=
                                      snapshot.data[index].uid.hashCode
                                  ? '${usersScreenViewModel.userModel.uid}_${snapshot.data[index].uid}'
                                  : '${snapshot.data[index].uid}_${usersScreenViewModel.userModel.uid}';
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
                                  '${snapshot.data[index].firstName.toCapitalized() ?? ''} ${snapshot.data[index].lastName.toCapitalized() ?? ''}',
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
                      ),
                    ],
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
    authService.userSignOut(context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (route) => false,
    );
  }
}
