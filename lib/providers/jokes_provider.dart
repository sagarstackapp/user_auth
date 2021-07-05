import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/constant/string_res.dart';
import 'package:user_auth/model/jokes_response.dart';
import 'package:http/http.dart' as http;

class JokesProvider extends ChangeNotifier {
  JokesResponse jokesResponse;

  Future<JokesResponse> fetchJokes(String category) async {
    try {
      String url = UrlResource.BaseUrl + 'random?category=' + category;
      print('Requested Url : $url');
      print('Selected category : $category');
      final response = await http.get(Uri.parse(url));
      print('StatusCodes : ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.body);
        print('Jokes Category : ${response.body}');
        Fluttertoast.showToast(
          msg: '${response.statusCode}',
          textColor: ColorResource.White,
          backgroundColor: ColorResource.Orange,
        );
        jokesResponse = JokesResponse.fromJson(responseJson);
        return JokesResponse.fromJson(responseJson);
      } else {
        Fluttertoast.showToast(
          msg: '${response.statusCode}',
          textColor: ColorResource.White,
          backgroundColor: ColorResource.Red,
        );
        return null;
      }
    } catch (e) {
      print('Catch error in Fetching Jokes : $e');
      return null;
    }
  }
}
