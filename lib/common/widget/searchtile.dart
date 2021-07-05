import 'package:flutter/material.dart';
import 'package:user_auth/common/constant/color_res.dart';

// ignore: must_be_immutable
class SearchTile extends StatelessWidget {
  String title;
  String email;
  VoidCallback onPressed;

  SearchTile({
    this.title,
    this.email,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? 'title',
                  style: TextStyle(color: ColorResource.White, fontSize: 20),
                ),
                SizedBox(height: 5),
                Text(
                  email ?? 'email',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: ColorResource.Grey),
                ),
              ],
            ),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Message',
                style: TextStyle(
                  fontSize: 20,
                  color: ColorResource.White,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                ColorResource.Blue,
              ),
            ),
          )
        ],
      ),
    );
  }
}
