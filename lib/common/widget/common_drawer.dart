import 'package:flutter/material.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/constant/image_res.dart';
import 'package:user_auth/common/widget/common_image_assets.dart';
import 'package:user_auth/page/jokes/jokes_category/jokes_category.dart';
import 'package:user_auth/page/search/users_screen.dart';
import 'package:user_auth/page/user_details/user_details.dart';

class CommonDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> drawerKey;
  final bool isUserScreen;
  final bool isChatScreen;
  final bool isJokesScreen;

  const CommonDrawer({
    Key key,
    this.drawerKey,
    this.isUserScreen = false,
    this.isChatScreen = false,
    this.isJokesScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorResource.darkGreen.withOpacity(0.3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          GestureDetector(
            onTap: () {
              drawerKey.currentState.openDrawer();
              if (!isUserScreen) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserDetails()),
                );
              }
            },
            child: menuItem(Icons.person_pin_rounded, 'My profile'),
          ),
          const Spacer(),
          GestureDetector(
              onTap: () {
                drawerKey.currentState.openDrawer();
                if (!isChatScreen) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UsersScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
              child: menuItem(Icons.wechat, 'Chat')),
          const Spacer(),
          GestureDetector(
            onTap: () {
              drawerKey.currentState.openDrawer();
              if (!isJokesScreen) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JokeCategory(),
                  ),
                );
              }
            },
            child: menuItem(Icons.celebration, 'Jokes Time'),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => drawerKey.currentState.openDrawer(),
            child: Hero(
              tag: 'profileTag',
              transitionOnUserGestures: true,
              child: Container(
                height: 48,
                width: 48,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorResource.white),
                ),
                child: const CommonImageAsset(
                  image: ImageResources.closeIcon,
                  color: ColorResource.white,
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

Column menuItem(IconData icon, String menuName) {
  return Column(
    children: [
      Icon(
        icon,
        size: 48,
        color: ColorResource.white,
      ),
      const SizedBox(height: 10),
      Text(
        menuName,
        style: const TextStyle(
          color: ColorResource.white,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    ],
  );
}
