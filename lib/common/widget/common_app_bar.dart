// ignore_for_file: missing_required_param

import 'package:flutter/material.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/constant/image_res.dart';
import 'package:user_auth/common/widget/common_image_assets.dart';

class CommonAppBar extends PreferredSize {
  final bool isHome;
  final double margin;
  final String title;
  final GestureTapCallback onDrawerTap;
  final bool showDrawer;

  const CommonAppBar({
    Key key,
    this.isHome = false,
    this.margin = 16,
    this.title = '',
    this.onDrawerTap,
    this.showDrawer = true,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!isHome)
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: EdgeInsets.only(right: margin, left: 24),
                  child: const CommonImageAsset(
                    image: ImageResources.backIOSIcon,
                    height: 20,
                    color: ColorResource.white,
                  ),
                ),
              ),
            if (isHome) const SizedBox(width: 24),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: ColorResource.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (showDrawer)
              InkWell(
                onTap: onDrawerTap,
                child: Hero(
                  tag: 'profileTag',
                  transitionOnUserGestures: true,
                  child: Container(
                    margin: EdgeInsets.only(right: margin, left: 24),
                    child: const CommonImageAsset(
                      image: ImageResources.drawerMenuIcon,
                      height: 20,
                      color: ColorResource.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
