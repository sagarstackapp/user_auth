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
    if (this.category == null) {
      print('JokesCategory data null');
    } else {
      data = this.category;
    }
    return data;
  }
}
