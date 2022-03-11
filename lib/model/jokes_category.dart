import 'package:user_auth/common/method/methods.dart';

class JokesCategories {
  final List<String> category;

  JokesCategories({
    this.category,
  });

  factory JokesCategories.fromJson(List<dynamic> jokesList) {
    return JokesCategories(
      category: jokesList == null ? null : List<String>.from(jokesList),
    );
  }

  List<dynamic> jokesMap() {
    List<dynamic> data = <String>[];
    if (category == null) {
      logs('JokesCategory data null');
    } else {
      data = category;
    }
    return data;
  }
}
