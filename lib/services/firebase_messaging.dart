import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:user_auth/common/method/methods.dart';

class FirebaseNotification {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> sendNotification() async {
    await firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      logs('Remote message Data : ${remoteMessage.data}');
      if (remoteMessage.notification == null) {
        logs('It not contains notification.!');
      } else {
        logs('It contains notification,${remoteMessage.notification.body}.!');
        logs('It contains notification,${remoteMessage.notification.title}.!');
      }
      showNotification(remoteMessage);
      return;
    });
  }

  AndroidNotificationChannel androidNotificationChannel =
      const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  showNotification(RemoteMessage remoteMessage) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      androidNotificationChannel.id,
      androidNotificationChannel.name,
      channelDescription: androidNotificationChannel.description,
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
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //     ======================= Generate Token =======================     //
  Future<String> firebaseToken(BuildContext context) async {
    try {
      var token = await firebaseMessaging.getToken();
      logs('Firebase Token --> $token');
      return token;
    } on FirebaseException catch (e) {
      logs('Catch error in Firebase Token --> ${e.message}');
      showMessage(context, e.message);
      return null;
    }
  }
}
