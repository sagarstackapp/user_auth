import 'package:flutter/material.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/constant/string_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/common/widget/common_app_bar.dart';
import 'package:user_auth/common/widget/common_image_assets.dart';
import 'package:user_auth/common/widget/common_loader.dart';
import 'package:user_auth/common/widget/widget.dart';
import 'package:user_auth/model/user_model.dart';
import 'package:user_auth/page/search/search_view_model.dart';
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
          floatingButton(Icons.doorbell, () {
            goJokeCategory(context);
          }, 'Jokes Category'),
          const SizedBox(height: 10),
          floatingButton(Icons.logout, () {
            authService.userSignOut();
            goSignIn(context);
          }, 'LogOut'),
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
                      return Card(
                        margin: const EdgeInsets.all(10),
                        elevation: 10,
                        shadowColor: ColorResource.grey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CommonImageAsset(
                                image: snapshot.data[index].image,
                                isWebImage: true,
                                webHeight: 40,
                                webWidth: 40,
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
}
