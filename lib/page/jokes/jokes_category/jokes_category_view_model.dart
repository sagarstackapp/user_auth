// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:user_auth/page/jokes/jokes_category/jokes_category.dart';
import 'package:user_auth/rest_api/jokes_category.dart';

class JokeCategoryViewModel {
  final JokeCategoryState jokeCategoryState;

  JokeCategoryViewModel(this.jokeCategoryState);

  Future<void> jokesApi(JokesCategoryProvider jokesCategoryProvider) async {
    jokesCategoryProvider.categoryList =
        jokeCategoryState.jokesCategoryProvider.categoryList;

    if (jokesCategoryProvider.categoryList.isEmpty) {
      jokesCategoryProvider.categoryList =
          await JokesCategoryProvider().fetchJokesCategory();
      if (jokesCategoryProvider.categoryList != null &&
          jokesCategoryProvider.categoryList.isNotEmpty) {
        jokeCategoryState.jokesCategoryProvider.categoryList =
            jokesCategoryProvider.categoryList;
      }
      jokesCategoryProvider.notifyListeners();
    }
  }
}
