import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import 'LocalNotificationService.dart';

//handle background messages.
@pragma('vm:entry-point')
Future<void> onBackgroundHandler(RemoteMessage message) async {
  LocalNotificationService.display(message);
}

class FcmService {
  late FirebaseMessaging messaging;

  Future<void> init(BuildContext context) async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(onBackgroundHandler);
    messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
    } else {}

    FirebaseMessaging.instance.getInitialMessage().then((message) {});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {}
      LocalNotificationService.display(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
  }

  Future<NotificationSettings> checkPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    return await messaging.getNotificationSettings();
  }

  Future<void> setPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
    } else {}
  }
}
