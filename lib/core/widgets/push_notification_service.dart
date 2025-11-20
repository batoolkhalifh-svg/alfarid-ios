import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  /// initialize firebase messaging
  static Future init() async {
    await messaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    await initializeLocalNotification();
    _handleForegroundMessage();
  }

  /// notification in background
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log(message.notification?.title ?? 'Background Notification');
  }

  /// local notification
  static Future initializeLocalNotification() async {
    const AndroidInitializationSettings settingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: settingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// notification in foreground
  static void _handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        const AndroidNotificationDetails androidDetails =
            AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        );

        const NotificationDetails platformDetails =
            NotificationDetails(android: androidDetails);

        await flutterLocalNotificationsPlugin.show(
          0,
          message.notification?.title ?? '',
          message.notification?.body ?? '',
          platformDetails,
        );
      },
    );
  }
}
