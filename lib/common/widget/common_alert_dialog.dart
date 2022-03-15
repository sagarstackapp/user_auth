import 'package:flutter/material.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/widget/elevated_button.dart';

class CustomAlertDialog extends StatefulWidget {
  final String title;
  final String message;
  final bool isAction;
  final GestureTapCallback onTap;
  final TextEditingController controller;

  const CustomAlertDialog({
    Key key,
    this.title = 'Message',
    this.message = 'No internet Connection',
    this.isAction = false,
    this.onTap,
    this.controller,
  }) : super(key: key);

  @override
  CustomAlertDialogState createState() => CustomAlertDialogState();
}

class CustomAlertDialogState extends State<CustomAlertDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: ColorResource.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorResource.darkGreen.withOpacity(0.8),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: ColorResource.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  height: 100,
                  width: double.infinity,
                  child: Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: ColorResource.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                widget.isAction
                    ? Row(
                        children: [
                          const Spacer(),
                          CommonElevatedButton(
                            text: 'Yes',
                            textSize: 16,
                            width: 80,
                            borderRadius: 8,
                            buttonColor:
                                ColorResource.darkGreen.withOpacity(0.8),
                            onPressed: () {
                              widget.onTap.call();
                            },
                          ),
                          const Spacer(),
                          CommonElevatedButton(
                            text: 'No',
                            textSize: 16,
                            width: 80,
                            borderRadius: 8,
                            buttonColor:
                                ColorResource.darkGreen.withOpacity(0.8),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                        ],
                      )
                    : GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          decoration: BoxDecoration(
                            color: ColorResource.darkGreen.withOpacity(0.8),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Okay',
                            style: TextStyle(
                              color: ColorResource.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                if (widget.isAction) const SizedBox(height: 8)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
