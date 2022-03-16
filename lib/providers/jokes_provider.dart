import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/constant/string_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/model/jokes_response.dart';

class JokesProvider extends ChangeNotifier {
  JokesResponse jokesResponse;

  Future<JokesResponse> fetchJokes(String category) async {
    try {
      String url = StringResources.baseUrl + 'random?category=' + category;
      logs('Requested Url : $url');
      logs('Selected category : $category');
      final response = await http.get(Uri.parse(url));
      logs('StatusCodes : ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.body);
        logs('Jokes Category : ${response.body}');
        Fluttertoast.showToast(
          msg: '${response.statusCode}',
          textColor: ColorResource.white,
          backgroundColor: ColorResource.orange,
        );
        jokesResponse = JokesResponse.fromJson(responseJson);
        return JokesResponse.fromJson(responseJson);
      } else {
        Fluttertoast.showToast(
          msg: '${response.statusCode}',
          textColor: ColorResource.white,
          backgroundColor: ColorResource.red,
        );
        return null;
      }
    } catch (e) {
      logs('Catch error in Fetching Jokes : $e');
      return null;
    }
  }
}
