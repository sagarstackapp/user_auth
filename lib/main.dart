import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:user_auth/page/search/search_page.dart';
import 'package:user_auth/page/sign_in/sign_in.dart';
import 'package:user_auth/providers/jokes_provider.dart';
import 'common/constant/color_res.dart';
import 'providers/jokes_category.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

List<SingleChildWidget> provider = [
  ChangeNotifierProvider<JokesCategory>(create: (context) => JokesCategory()),
];

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userLogin = false;
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    logInCheck();
  }

  logInCheck() async {
    bool user = await authService.userLogInCheck();
    setState(() {});
    userLogin = user;
  }

  List<SingleChildWidget> providers = [
    ChangeNotifierProvider<JokesCategory>(create: (context) => JokesCategory()),
    ChangeNotifierProvider<JokesProvider>(create: (context) => JokesProvider()),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Firebase User Integration',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: ColorResource.Grey.withOpacity(0.4),
        ),
        home: userLogin ? Search() : SignIn(),
      ),
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message Id : ${message.messageId}');
  print('Background message Time : ${message.sentTime}');
}
