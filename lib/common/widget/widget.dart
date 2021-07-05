import 'package:flutter/material.dart';
import 'package:user_auth/common/constant/color_res.dart';

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
    validator: (value) {
      if (value.isEmpty) {
        return 'Email address can\'t be empty!';
      }
      if (!RegExp(r"^[a-z0-9.a-z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-z0-9]+\.[a-z]+")
          .hasMatch(value)) {
        return 'Enter a valid username.!';
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
    validator: (value) {
      if (value.isEmpty) {
        return 'Password can\'t be empty!';
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

Widget topMenuBar(BuildContext context, String title) {
  return PreferredSize(
    child: AppBar(
      title: Center(child: Text(title)),
      elevation: 20,
    ),
    preferredSize: Size(double.infinity, 80),
  );
}

Widget titleText(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20.0),
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25,
        color: ColorResource.White,
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
    style: TextStyle(color: ColorResource.Black, fontSize: 20),
  );
}

Widget textHeader(GestureTapCallback onTap, String text) {
  return InkWell(
    onTap: onTap,
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: ColorResource.White,
      ),
    ),
  );
}

Widget elevatedButton(String text, VoidCallback onPressed) {
  return CommonElevatedButton(
    text: text,
    textColor: ColorResource.White,
    buttonColor: ColorResource.Blue,
    onPressed: onPressed,
  );
}

Widget headerText(String text) {
  return Text(
    text,
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
        Center(
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
        color: ColorResource.White.withOpacity(0.5),
      ),
      onPressed: onPressed,
    ),
  );
}
