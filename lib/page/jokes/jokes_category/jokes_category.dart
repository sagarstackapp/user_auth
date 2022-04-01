import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/constant/string_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/common/widget/common_app_bar.dart';
import 'package:user_auth/common/widget/common_drawer.dart';
import 'package:user_auth/common/widget/common_loader.dart';
import 'package:user_auth/page/jokes/jokes_category/jokes_category_view_model.dart';
import 'package:user_auth/page/jokes/jokes_list/jokes_list.dart';
import 'package:user_auth/rest_api/jokes_category.dart';
import 'package:user_auth/services/auth_service.dart';

class JokeCategory extends StatefulWidget {
  const JokeCategory({Key key}) : super(key: key);

  @override
  JokeCategoryState createState() => JokeCategoryState();
}

class JokeCategoryState extends State<JokeCategory> {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  AuthService authService = AuthService();
  JokesCategoryProvider jokesCategoryProvider;
  JokeCategoryViewModel jokeCategoryViewModel;

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    jokesCategoryProvider =
        Provider.of<JokesCategoryProvider>(context, listen: false);
    jokeCategoryViewModel ??
        (jokeCategoryViewModel = JokeCategoryViewModel(this));
    return Scaffold(
      key: drawerKey,
      endDrawerEnableOpenDragGesture: false,
      appBar: CommonAppBar(
        title: StringResources.jokesCategory,
        onDrawerTap: () => drawerKey.currentState.openEndDrawer(),
      ),
      endDrawer: CommonDrawer(drawerKey: drawerKey, isJokesScreen: true),
      body: ChangeNotifierProvider<JokesCategoryProvider>(
        create: (BuildContext context) {
          return JokesCategoryProvider();
        },
        child: Consumer<JokesCategoryProvider>(
          builder: (BuildContext context, provider, Widget child) {
            if (provider.categoryList.isEmpty) {
              jokeCategoryViewModel.jokesApi(provider);
            }
            return provider.categoryList.isNotEmpty
                ? ListView.builder(
                    primary: true,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: provider.categoryList.length,
                    itemBuilder: (context, index) {
                      String categoryName =
                          provider.categoryList[index].toCapitalized();
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JokeList(
                              selectedCategory: categoryName,
                            ),
                          ),
                        ),
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          elevation: 0,
                          shadowColor: ColorResource.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            title: Text(
                              categoryName.toCapitalized(),
                              style: const TextStyle(
                                color: ColorResource.darkGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const LoadingPage();
          },
        ),
      ),
    );
  }
}
