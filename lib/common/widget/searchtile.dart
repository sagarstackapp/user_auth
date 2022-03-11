import 'package:flutter/material.dart';
import 'package:user_auth/common/constant/color_res.dart';

class SearchTile extends StatelessWidget {
  final String title;
  final String email;
  final VoidCallback onPressed;

  const SearchTile({
    Key key,
    this.title,
    this.email,
    this.onPressed,
  }) : super(key: key);

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
                  style:
                      const TextStyle(color: ColorResource.white, fontSize: 20),
                ),
                const SizedBox(height: 5),
                Text(
                  email ?? 'email',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: ColorResource.grey),
                ),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: onPressed,
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Message',
                style: TextStyle(
                  fontSize: 20,
                  color: ColorResource.white,
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
                ColorResource.blue,
              ),
            ),
          )
        ],
      ),
    );
  }
}
