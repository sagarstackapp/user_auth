import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/constant/string_res.dart';
import 'package:user_auth/model/jokes_category.dart';

class JokesCategory extends ChangeNotifier {
  JokesCategories jokesCategories;

  Future<JokesCategories> fetchJokesCategory() async {
    try {
      String url = UrlResource.BaseUrl + 'categories';
      print('Requested Url : $url');
      final response = await http.post(Uri.parse(url));
      print('StatusCodes : ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.body);
        print('Jokes Category : ${response.body}');
        Fluttertoast.showToast(
          msg: '${response.statusCode}',
          textColor: ColorResource.White,
          backgroundColor: ColorResource.Orange,
        );
        jokesCategories = JokesCategories.fromJson(responseJson);
        return JokesCategories.fromJson(responseJson);
      } else {
        Fluttertoast.showToast(
          msg: '${response.statusCode}',
          textColor: ColorResource.White,
          backgroundColor: ColorResource.Red,
        );
        return null;
      }
    } catch (e) {
      print('Catch error in Fetching Jokes Category : $e');
      return null;
    }
  }
}
