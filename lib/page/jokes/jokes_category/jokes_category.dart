import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/constant/string_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/common/widget/common_app_bar.dart';
import 'package:user_auth/page/jokes/jokes_category/jokes_category_view_model.dart';
import 'package:user_auth/page/sign_in/sign_in.dart';
import 'package:user_auth/providers/jokes_category.dart';
import 'package:user_auth/services/auth_service.dart';

class JokeCategory extends StatefulWidget {
  const JokeCategory({Key key}) : super(key: key);

  @override
  JokeCategoryState createState() => JokeCategoryState();
}

class JokeCategoryState extends State<JokeCategory> {
  AuthService authService = AuthService();
  JokesCategoryProvider jokesCategoryProvider;
  JokeCategoryViewModel jokeCategoryViewModel;

  @override
  Widget build(BuildContext context) {
    jokesCategoryProvider =
        Provider.of<JokesCategoryProvider>(context, listen: false);
    jokeCategoryViewModel ??
        (jokeCategoryViewModel = JokeCategoryViewModel(this));
    return Scaffold(
      appBar: const CommonAppBar(title: StringResources.jokesCategory),
      body: ChangeNotifierProvider<JokesCategoryProvider>(
        create: (BuildContext context) {
          return JokesCategoryProvider();
        },
        child: Consumer<JokesCategoryProvider>(
          builder: (BuildContext context, provider, Widget child) {
            if (provider.categoryList.isEmpty) {
              jokeCategoryViewModel.jokesApi(provider);
            }
            return ListView.builder(
              primary: true,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: provider.categoryList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 0,
                  shadowColor: ColorResource.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    title: Text(
                      provider.categoryList[index].toCapitalized(),
                      style: const TextStyle(
                        color: ColorResource.darkGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.exit_to_app_outlined),
        onPressed: () async {
          await authService.userSignOut();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignIn()),
            (route) => false,
          );
        },
      ),
    );
  }
}
