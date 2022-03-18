import 'package:user_auth/common/app/app_state.dart';

AppState appState = AppState();

class StringResources {
  static const String title = 'Firebase User Integration';
  static const String signIn = 'Sign In';
  static const String bioSignIn = 'BioMetrics';
  static const String register = 'Register';
  static const String jokesCategory = 'Jokes Category';
  static const String accountRequest = 'Don\'t have an account?';
  static const String logInRequest = 'Already have account?';
  static const String signInOption = 'Register';
  static const String signUpOption = 'Login';
  static const String forgotPassword = 'Forgot Password';
  static const String get = 'Get Link';

  //     ======================= Regular Expressions =======================     //
  static const String emailRegExp =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{3,}))$';
  static const String passwordRegexp =
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{0,}$";
  static const String urlRegexp = r"^http[s]?:\/\/(www\.)?(.*)?\/?(.)*";
  static const String phoneRegexp = r"^(?:[+0]9)?[0-9]{10}$";

  //     ======================= API url =======================     //
  static const String baseUrl = 'https://api.chucknorris.io/jokes';
}
