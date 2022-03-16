// ignore_for_file: invalid_use_of_protected_member

import 'package:user_auth/model/jokes_response.dart';
import 'package:user_auth/page/jokes/jokes_list/jokes_list.dart';
import 'package:user_auth/rest_api/jokes_category.dart';

class JokeListViewModel {
  final JokeListState jokeListState;
  JokesResponse joke;

  JokeListViewModel(this.jokeListState) {
    jokesApi();
  }

  Future<void> jokesApi() async {
    JokesResponse jokesResponse = await JokesCategoryProvider().fetchJokes(
        category: jokeListState.widget.selectedCategory.toLowerCase());
    if (jokesResponse != null) {
      joke = jokesResponse;
    }
    jokeListState.setState(() {
      jokeListState.isLoading = false;
    });
  }
}
