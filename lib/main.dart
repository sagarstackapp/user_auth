import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:user_auth/common/app/shared_preference.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/page/search/users_screen.dart';
import 'package:user_auth/page/sign_in/sign_in.dart';
import 'package:user_auth/rest_api/jokes_category.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  bool isLoggedIn = await getPrefBoolValue(isLogIn) ?? false;
  bool isSocLoggedIn = await getPrefBoolValue(isSocialLogin) ?? false;
  runApp(MyApp(isLoggedIn: isLoggedIn, isSocLoggedIn: isSocLoggedIn));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  final bool isSocLoggedIn;

  const MyApp({Key key, this.isLoggedIn = false, this.isSocLoggedIn = false})
      : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final messengerKey = GlobalKey<ScaffoldMessengerState>();
  StreamSubscription<ConnectivityResult> connectivitySubscription;
  Connectivity connectivity = Connectivity();
  List<SingleChildWidget> providers = [
    ChangeNotifierProvider<JokesCategoryProvider>(
        create: (context) => JokesCategoryProvider()),
  ];
  bool isBioMetrics = false;

  @override
  void initState() {
    checkBioMetrics();
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult event) {
      messengerKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: event == ConnectivityResult.none
              ? ColorResource.red
              : ColorResource.lightGreen,
          content: Text(
            event == ConnectivityResult.none
                ? 'Device is Offline'
                : 'Back online',
            style: const TextStyle(color: ColorResource.white),
          ),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        scaffoldMessengerKey: messengerKey,
        title: 'Firebase User Integration',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: ColorResource.darkGreen,
          fontFamily: 'Ubuntu',
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            color: ColorResource.darkGreen,
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: ColorResource.darkGreen,
            selectionColor: ColorResource.darkGreen.withOpacity(0.2),
            selectionHandleColor: ColorResource.darkGreen,
          ),
        ),
        home: ((widget.isLoggedIn || widget.isSocLoggedIn) && isBioMetrics)
            ? const UsersScreen()
            : const SignInScreen(),
      ),
    );
  }

  Future<void> checkBioMetrics() async {
    if (widget.isLoggedIn || widget.isSocLoggedIn) {
      isBioMetrics = await bioMetricsVerification(context);
      logs('isBioMetrics message --> $isBioMetrics');
      setState(() {});
      if (isBioMetrics) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const UsersScreen()),
          (route) => false,
        );
      }
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  logs('Background message Id : ${message.messageId}');
  logs('Background message Time : ${message.sentTime}');
}
