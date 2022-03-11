import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/common/widget/common_app_bar.dart';
import 'package:user_auth/common/widget/widget.dart';
import 'package:user_auth/model/jokes_category.dart';
import 'package:user_auth/providers/jokes_category.dart';
import 'package:user_auth/services/auth_service.dart';

import 'jokes_list.dart';

class JokeCategory extends StatefulWidget {
  const JokeCategory({Key key}) : super(key: key);

  @override
  _JokeCategoryState createState() => _JokeCategoryState();
}

class _JokeCategoryState extends State<JokeCategory> {
  AuthService authService = AuthService();
  JokesCategories jokesCategories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Jokes Categories'),
      body: FutureBuilder<JokesCategories>(
        future: Provider.of<JokesCategory>(context, listen: false)
            .fetchJokesCategory(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(
                child: Text(
                  'Fetch opportunity data',
                  textAlign: TextAlign.center,
                ),
              );
            case ConnectionState.active:
              return const Center(
                child: Text(''),
              );
            case ConnectionState.waiting:
              return const Center(
                child: Text(
                  'Connection waiting...',
                  textAlign: TextAlign.center,
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return showAPILoader(context);
              } else {
                jokesCategories = snapshot.data;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: jokesCategories.category.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        jokesCategories.category[index],
                        style: const TextStyle(
                          color: ColorResource.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => JokeList(
                                  selectedCategory:
                                      jokesCategories.category[index],
                                )));
                      },
                    );
                  },
                );
              }
          }
          return showAPILoader(context);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.exit_to_app_outlined),
        onPressed: () {
          authService.userSignOut();
          goToSignIn(context);
        },
      ),
    );
  }

  goToSignIn(BuildContext context) {
    goSignIn(context);
  }
}
