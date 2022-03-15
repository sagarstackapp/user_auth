import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:user_auth/common/app/shared_preference.dart';
import 'package:user_auth/common/method/methods.dart';
import 'package:user_auth/page/search/search_page.dart';
import 'package:user_auth/page/sign_in/sign_in.dart';
import 'package:user_auth/providers/jokes_provider.dart';

import 'common/constant/color_res.dart';
import 'providers/jokes_category.dart';

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
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<SingleChildWidget> providers = [
    ChangeNotifierProvider<JokesCategory>(create: (context) => JokesCategory()),
    ChangeNotifierProvider<JokesProvider>(create: (context) => JokesProvider()),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
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
        home: (widget.isLoggedIn || widget.isSocLoggedIn)
            ? const Search()
            : const SignIn(),
      ),
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  logs('Background message Id : ${message.messageId}');
  logs('Background message Time : ${message.sentTime}');
}
