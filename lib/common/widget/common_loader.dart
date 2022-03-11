import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:user_auth/common/constant/color_res.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: ColorResource.white.withOpacity(0.8),
        child: const SpinKitSpinningLines(
          color: ColorResource.darkGreen,
          size: 42,
        ),
      ),
    );
  }
}
