import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/constant/string_res.dart';

import 'elevated_button.dart';
import 'text_form_field.dart';

Widget firstName(TextEditingController controller) {
  return CommonTextFormField(
    controller: controller,
    hintText: 'Enter Firstname',
    validator: (value) {
      if (value.isEmpty) {
        return 'First name can\'t be empty!';
      }
      if (!RegExp(r"^[a-zA-Z]+").hasMatch(value)) {
        return 'Enter a valid first name.!';
      }
      return null;
    },
  );
}

Widget lastName(TextEditingController controller) {
  return CommonTextFormField(
    controller: controller,
    hintText: 'Enter Last Name',
    validator: (value) {
      if (value.isEmpty) {
        return 'Last name can\'t be empty!';
      }
      if (!RegExp(r"^[a-zA-Z]+").hasMatch(value)) {
        return 'Enter a valid lastname.!';
      }
      return null;
    },
  );
}

Widget email(TextEditingController controller) {
  return CommonTextFormField(
    controller: controller,
    hintText: 'Enter Email Address',
    keyboardType: TextInputType.emailAddress,
    prefixIcon: Icons.person_rounded,
    validator: (value) {
      if (value.isEmpty) {
        return 'Email address can\'t be empty!';
      }
      if (!RegExp(StringResources.emailRegExp).hasMatch(value)) {
        return 'Please enter valid Email.!';
      }
      return null;
    },
  );
}

Widget password(TextEditingController controller) {
  return CommonTextFormField(
    controller: controller,
    hintText: 'Enter password',
    obscureText: true,
    prefixIcon: Icons.lock_open_rounded,
    inputFormatters: [
      LengthLimitingTextInputFormatter(8),
    ],
    validator: (value) {
      if (value.isEmpty) {
        return 'Password can\'t be empty!';
      }
      if (!RegExp(StringResources.passwordRegexp).hasMatch(value)) {
        return 'Password must contains number, alphabet & special character';
      }
      if (controller.text.length < 8) {
        return 'Password must be 8 character long.!';
      }
      return null;
    },
  );
}

Widget confirmPassword(
    TextEditingController controller, TextEditingController controller1) {
  return CommonTextFormField(
    controller: controller,
    hintText: 'Enter password again',
    obscureText: true,
    validator: (value) {
      if (value.isEmpty) {
        return 'Confirm password can\'t be empty!';
      }
      if (controller.text.length < 8) {
        return 'Confirm password must be 8 character long.!';
      }
      if (controller1.text != controller.text) {
        return 'Password do not matching.!';
      }
      return null;
    },
  );
}

Widget typeMessageField(TextEditingController controller) {
  return CommonTextFormField(
    controller: controller,
    hintText: 'Type a message...',
    validator: (value) {
      if (value.isEmpty) {
        return 'Message can\'t be empty!';
      }
      return null;
    },
  );
}

Widget titleText(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20.0),
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 25,
        color: ColorResource.white,
        wordSpacing: 3,
        letterSpacing: 1,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget textBody(String text) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: const TextStyle(color: ColorResource.black, fontSize: 20),
  );
}

Widget textHeader(GestureTapCallback onTap, String text) {
  return InkWell(
    onTap: onTap,
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: ColorResource.white,
      ),
    ),
  );
}

Widget elevatedButton(String text, VoidCallback onPressed) {
  return CommonElevatedButton(
    text: text,
    textColor: ColorResource.white,
    buttonColor: ColorResource.blue,
    onPressed: onPressed,
  );
}

Widget headerText(String text) {
  return Text(
    text,
    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
  );
}

Widget showAPILoader(BuildContext context) {
  return Center(
    child: Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
        ),
        const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.orange),
            strokeWidth: 5,
            backgroundColor: Colors.white,
          ),
        )
      ],
    ),
  );
}

Widget floatingButton(IconData icon, VoidCallback onPreses, String heroTag) {
  return FloatingActionButton(
    child: Icon(icon),
    onPressed: onPreses,
    heroTag: heroTag,
  );
}

Widget chatIcon(double margin, IconData icon, VoidCallback onPressed) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: margin),
    child: IconButton(
      icon: Icon(
        icon,
        color: ColorResource.white.withOpacity(0.5),
      ),
      onPressed: onPressed,
    ),
  );
}
