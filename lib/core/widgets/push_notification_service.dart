import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:googleapis_auth/auth_io.dart' as auth;



class NotificationsService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future init() async {
    await messaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    handleForegroundMessage();
  }
  ///  notification background
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log(message.notification?.title ?? 'null');
  }



  static Future initializeLocalNotification() async {
    var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    handleForegroundMessage();
  }

  ///  notification foreground
  static void handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) async{
        // show local notification
        AndroidNotificationDetails android = const AndroidNotificationDetails(
            'channel_id',
            'channel_name',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            icon: '@mipmap/ic_launcher'
        );
        NotificationDetails details = NotificationDetails(
          android: android,
        );
        await flutterLocalNotificationsPlugin.show(
          0,
          message.notification?.title,
          message.notification?.body,
          details,
        );

      },
    );
  }

}

class PushNotificationsService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "retreat-819ef",
      "private_key_id": "083d2126cc90b8ce6491dac8254c80a347dd5e8a",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDgKMc1Suq9J5CS\nUukvFNGNNcCfICYp8xSfkAT0dIxyxMBNmp/RoSatg8a5ZDaAAfoRTfWb2x0Z5jXJ\nbTx2t37ki7/EMBpokFkpFSOlhGvGuRe4TsIAGNDGeoOq1W96E2hZSSvm6Cvftpw5\nlHTOlw8D89PTY2yqPNGG1TkL1kaa+BzmL6oElnf7gs9nVziUDi5ddHvtsPoj0hxK\njci97OkaIi4Tw1g1ih17GSWWAWIN2Vidb+IyRaRi9UVrgJKcGFVLP4SxTiObw5d0\nzNLo9Pgb05iSGlEJwqFUqewnHJeKXQGm1fTh4dgsiUqIuZFhGtarll9c1xdGjVaq\nZ2MQcdJTAgMBAAECggEAAWtynkUH4ZOJA6JQ9UojySYDU3cATUcnxj5NJohUrhzt\nI/7EWoY4kSvkDSlsZ2xZONUn2ep+mKZ6GANrs++BWHCAEhImUui8k/0dC+yQbJW/\nIBzzvs0hwTe9WQbNmVidj7x8tFX4MDU4zCmF3aDw0Zr9YL7ts58fY84mJ9N6Hz4s\nkwtZetJ9uEht3doWyR+QcOU6ys4eDyDBzTBI0FrsWQd1sTewo7VlGLA+NRSfGor+\n+FpViuc0be3Y3rWfUII1+Wt8p9OZdT9bVsRuD2Od8LnNquvriD/jlHymlDwc9fnL\n6jPvNUaK/G0yp8hN7aW8SzyJMAZjm2puYuci7dE3kQKBgQDxPdLjgE+hLjtGUz9d\nxSL6okIgptq2qrR717mhg/LkUjWWJcAxdDZimeIn0DYrt5iIv1R/VtOzYcerVev2\nTtBItyEh/3b+NMFEAImWfnlMsU3r3FN1/DoymuJzK77CP+7dzVEFcLbB95PnttOB\nJ9PBQSW5XwFOnEYninaDFZSXWwKBgQDt32xdRHk55HOHRuQsNiTgtGsRawi/fFAY\negdXgXv3Pep4k29q0gg2U3lX/Qlj5knxsm0br6OYIoi1ZWFU5np/UwBqEzQTMRJL\nutzQbIIBAbv6K66Yu++1ExcRBPSkqSoYAittDiYQv7yk2Uy+0WcK8sW+r4W8GuwN\nUXn4h8maaQKBgCyoaTW8NwF7cXWfS4esSsFi8CLjQHG4QBj84lxH9NrXbRwSePWu\nsbKnEfqUzLJjFlWaNaYtCJuYakIJcdjy1hPf8r48cGa2lWBlSRMW7pWH7QjQjJK2\n0n8ztN/lJTcIZsuginMbXnmhvzuR2K18FfMcgENElxVaUJJZS38Qq6UpAoGAdPPq\ntZia+cnGu3YxbUNZsllCYxf6/xrBzqcAwRdaud7pT0s99ok5nGxCNu6kFUf+hyUw\n2/HpPz2LdZRY3INNKxjGFWFHsz/nPPCs7JTM/m253HBpsZKFcsPmDWogVm0N0ywN\n6dqRAJ8kwvBL+W2/efSPIQfveuLJuGqcy4MHrjECgYEAlvxkKola5qgFEeilop3j\nArjnq9l8z0jrwy4UPTCnbQuJ1NPE8pMhAFuPyEN0QGP7nDPrFguoKiBdcu7lcs5k\nopjV3J/eeosOa4YkCZo8XSQ0XqGIkFEv5qgu0X/tb6EO7YCjudMU21U+9bd8ewMt\n/p4/hHxuupmzpJxY+7pZeLQ=\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-kn9d2@retreat-819ef.iam.gserviceaccount.com",
      "client_id": "105409789732754063158",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-kn9d2%40retreat-819ef.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    final client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );
    auth.AccessCredentials credentials =
    await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client);
    client.close();
    return credentials.accessToken.data;
  }


  static  Future<void> sendNotification(
      {required String msg,
        required String token,
        required String name}) async {
    String accessToken = await getAccessToken();
    final response = await Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 11),
        validateStatus: (int? status) => status! >= 200 && status <= 500,
        headers: {
          "Accept": "application/json",
          "Accept-Language": "en",
          'Authorization': "Bearer $accessToken",
        })
    ).post(
        "https://fcm.googleapis.com/v1/projects/retreat-819ef/messages:send",
        data: {
          "message": {
            "token": token,
            "notification": {
              "title": name,
              "body": msg,
            },
          },
        }
    );
    log(response.toString());
    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification');
    }
  }


}
