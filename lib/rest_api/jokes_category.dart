import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:user_auth/common/constant/string_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/model/jokes_response.dart';

List<String> jokesCategoryModelFromJson(String str) =>
    List<String>.from(json.decode(str).map((x) => x));

class JokesCategoryProvider extends ChangeNotifier {
  List<String> categoryList = [];

  Future<List<String>> fetchJokesCategory() async {
    try {
      String url = '${StringResources.baseUrl}/categories';
      logs('Url --> $url');
      Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200 || response.statusCode == 201) {
        logs('Jokes Category --> ${response.body}');
        return jokesCategoryModelFromJson(response.body);
      } else {
        logs('Response StatusCode --> ${response.statusCode}');
        return null;
      }
    } on ClientException catch (e) {
      logs('Catch error in Fetching Jokes Category --> ${e.message}');
      return null;
    }
  }

  Future<JokesResponse> fetchJokes({@required String category}) async {
    try {
      String url = '${StringResources.baseUrl}/random?category=$category';
      logs('Url --> $url');
      Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200 || response.statusCode == 201) {
        logs('Jokes --> ${response.body}');
        return jokesResponseFromJson(response.body);
      } else {
        logs('Response StatusCode --> ${response.statusCode}');
        return null;
      }
    } on ClientException catch (e) {
      logs('Catch error in Fetching Jokes --> ${e.message}');
      return null;
    }
  }
}
