import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'CriticalNotificationManager.dart';

class LocalNotificationService {
  static const String criticalChannel = "critical-alert-channel";
  static const String defaultChannel = "default-channel";
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _alertChannel =
      AndroidNotificationChannel(
    criticalChannel,
    'High important channel',
    description: 'Receive critical push notification',
    showBadge: true,
    playSound: true,
    importance: Importance.high,
    enableVibration: true,
  );

  static const AndroidNotificationChannel _defaultChannel =
      AndroidNotificationChannel(
    defaultChannel,
    'Default channel',
    showBadge: true,
    playSound: true,
    importance: Importance.high,
    enableVibration: true,
  );

  static void initialize(BuildContext context) async {
    try {
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        iOS: DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        ),
      );

      _notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (route) {
          if (route != null) {
            Navigator.of(context).pushNamed(route as String);
          }
        },
      );

      final bool? result = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      //request notification permission
      _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            _alertChannel,
          );

      _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_defaultChannel);
    } catch (e) {}
  }

  static void display(RemoteMessage message) {
    if (message.data["critical"] == "true") {
      if (Platform.isAndroid) {
        CriticalNotificationManager().manageCriticalNotificationAccess();
      }
    }
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          criticalChannel,
          "High important channel",
          channelDescription: "Receive alert push notification by this channel",
          importance: Importance.max,
          priority: Priority.max,
          ongoing: true,
          enableVibration: true,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentSound: true,
        ),
      );

      const NotificationDetails notificationDetailsNoSound =
          NotificationDetails(
        android: AndroidNotificationDetails(
          defaultChannel,
          "Default notification channel ",
          channelDescription:
              "Default channel to receive all normal notification message",
          importance: Importance.high,
          priority: Priority.high,
          ongoing: true,
          enableVibration: true,
        ),
      );
      _notificationsPlugin.show(
        id,
        message.data["title"],
        message.data["body"],
        message.data["critical"] == "true"
            ? notificationDetails
            : notificationDetailsNoSound,
        //notificationDetails,
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
