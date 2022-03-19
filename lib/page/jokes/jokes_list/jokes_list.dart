import 'package:flutter/material.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/common/widget/common_app_bar.dart';
import 'package:user_auth/common/widget/common_image_assets.dart';
import 'package:user_auth/common/widget/common_loader.dart';
import 'package:user_auth/page/jokes/jokes_list/jokes_list_view_model.dart';

class JokeList extends StatefulWidget {
  final String selectedCategory;

  const JokeList({
    Key key,
    @required this.selectedCategory,
  }) : super(key: key);

  @override
  JokeListState createState() => JokeListState();
}

class JokeListState extends State<JokeList> {
  JokeListViewModel jokeListViewModel;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    jokeListViewModel ?? (jokeListViewModel = JokeListViewModel(this));
    return Scaffold(
      appBar: CommonAppBar(
        title: '${widget.selectedCategory}\'s Jokes',
        showDrawer: false,
      ),
      body: Stack(
        children: [
          jokeListViewModel.joke != null
              ? Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.8,
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 2.8,
                          margin: const EdgeInsets.only(top: 60),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(
                              left: 30, right: 18, top: 30),
                          decoration: BoxDecoration(
                            color: ColorResource.white,
                            borderRadius: BorderRadius.circular(26),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF303030).withOpacity(0.4),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(4, 10),
                              ),
                            ],
                          ),
                          child: Text(
                            jokeListViewModel.joke.value.toCapitalized(),
                            style: const TextStyle(
                              color: ColorResource.darkGreen,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          height: 120,
                          width: 120,
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                            color: ColorResource.lightGreen,
                            borderRadius: BorderRadius.circular(26),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF303030).withOpacity(0.4),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(4, 10),
                              ),
                            ],
                          ),
                          child: CommonImageAsset(
                            isWebImage: true,
                            image: jokeListViewModel.joke.iconUrl,
                            webWidth: double.infinity,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          isLoading ? const LoadingPage() : Container(),
        ],
      ),
    );
  }
}
