import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:user_auth/common/constant/color_res.dart';

logs(String message) {
  if (kDebugMode) {
    print(message);
  }
}

showMessage(BuildContext context, String message,
    {Color textColor = ColorResource.white}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
    ),
  );
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
