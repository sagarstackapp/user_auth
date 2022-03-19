import 'package:firebase_auth/firebase_auth.dart';

enum LogInType { firebase, google, facebook }
enum MessageType { attachment, message }

class AppState {
  User user;
}
