// ignore_for_file: missing_required_param

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/constant/image_res.dart';
import 'package:user_auth/common/widget/common_image_assets.dart';

class CommonAppBar extends PreferredSize {
  final String title;
  final double titleSize;
  final double margin;
  final String actionTitle;
  final GestureTapCallback onTap;
  final bool details;
  final bool showDrawer;
  final bool isHome;
  final int flex;
  final GestureTapCallback onDrawerTap;
  final GestureTapCallback onBackTap;

  const CommonAppBar({
    Key key,
    this.title,
    this.margin,
    this.titleSize,
    this.actionTitle,
    this.onTap,
    this.details = false,
    this.showDrawer = false,
    this.isHome = false,
    this.flex = 0,
    this.onDrawerTap,
    this.onBackTap,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!isHome)
            InkWell(
              onTap: () {
                if (onBackTap != null) onBackTap.call();
                if (onBackTap == null) Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(right: margin ?? 18, left: 24),
                child: SvgPicture.asset(
                  ImageResources.backIOSIcon,
                  height: 18,
                ),
              ),
            ),
          if (isHome) const SizedBox(width: 24),
          Flexible(
            flex: flex,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ColorResource.black,
                fontSize: titleSize ?? 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Spacer(),
          details
              ? showDrawer
                  ? InkWell(
                      onTap: onDrawerTap,
                      child: const CommonImageAsset(
                        image: ImageResources.drawerMenuIcon,
                        color: ColorResource.black,
                      ),
                    )
                  : Container()
              : InkWell(
                  onTap: onTap,
                  child: Text(
                    actionTitle ?? '',
                    style: const TextStyle(
                      color: ColorResource.grey,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
