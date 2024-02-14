import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_koro/models/chat_users_model.dart';
import 'package:chat_koro/services/fiirestore_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:http/http.dart';

class NotificationApi {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<void> getMessageToken() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await messaging.getToken().then((token) {
      if (token != null) {
        FireStoreServices.me.pushToken = token;
        log(token);
      }
    });
  }

  static Future<void> sendNotification(ChatUser user, String msg) async {
    try {
      final body = {
        "to": user.pushToken,
        "notification": {
          "title": user.name,
          "body": msg,
          "android_channel_id": "chats",
        },
        "data": {
          "some_data": "User_id:${FireStoreServices.me.id}",
        },
      };
      var response =
          await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/Json',
                HttpHeaders.authorizationHeader:
                    'key=AAAA71EQTos:APA91bGCmHHNSmkvM3xhbUzx7lwMqJxw4qxhC8Ai8hFZHqG_GCMAvEbuvIH2PVQNvbdW1WRfNUokyJ_QvqMRywHhhlIebS2DfDdloXIuSQoBwhyj2ruwfQ6r-LwNd5KkjTwJJmlgkXBE',
              },
              body: jsonEncode(body));
      log('\n response status: ${response.statusCode}');
      log('\n response body: ${response.body}');
    } catch (e) {
      log('\n${e.toString()}');
    }
  }

  static notificationChannel() async {
    var result = await FlutterNotificationChannel.registerNotificationChannel(
      description: 'to send notification',
      id: 'chats',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'Chats',
    );
    log(result);
  }
}
