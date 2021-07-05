import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseNotification {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> sendNotification() async {
    await firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      print('Remote message Data : ${remoteMessage.data}');
      if (remoteMessage.notification == null) {
        print('It not contains notification.!');
      } else {
        print('It contains notification,${remoteMessage.notification.body}.!');
        print('It contains notification,${remoteMessage.notification.title}.!');
      }
      showNotification(remoteMessage);
      return;
    });
  }

  AndroidNotificationChannel androidNotificationChannel =
      AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    'This channel is used for important notifications.',
    importance: Importance.high,
  );

  showNotification(RemoteMessage remoteMessage) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      androidNotificationChannel.id,
      androidNotificationChannel.name,
      androidNotificationChannel.description,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      remoteMessage.notification.title,
      remoteMessage.notification.body,
      platformChannelSpecifics,
      payload: json.encode(remoteMessage.toString()),
    );
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //     ======================= Generate Token =======================     //
  Future<String> firebaseToken() async {
    try {
      var token = await firebaseMessaging.getToken();
      print('Firebase Token : $token');
      return token;
    } on Exception catch (e) {
      print('Catch error in Firebase Token : $e');
      return '$e';
    }
  }
}
