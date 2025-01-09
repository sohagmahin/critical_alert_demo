import 'dart:io';

import 'package:critical_alert/FcmService.dart';
import 'package:critical_alert/LocalNotificationService.dart';
import 'package:do_not_disturb/do_not_disturb_plugin.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_critical_alert_permission_ios/flutter_critical_alert_permission_ios.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Critical Alert Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static Future<void> requestDoNotDisturbPermission(
      BuildContext context) async {
    final dndPlugin = DoNotDisturbPlugin();
    bool hasAccess = await dndPlugin.isNotificationPolicyAccessGranted();

    if (!hasAccess) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Allow this app to access Do Not Disturb'),
            content: const Text(
                'This will allow the app to manage Do Not Disturb settings'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  await dndPlugin.openNotificationPolicyAccessSettings();
                  Navigator.of(context).pop();
                },
                child: const Text("Open Settings"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void didChangeDependencies() {
    if (Platform.isIOS) {
      FlutterCriticalAlertPermissionIos.requestCriticalAlertPermission();
    }

    if (Platform.isAndroid) {
      requestDoNotDisturbPermission(context);
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    LocalNotificationService.initialize(context);
    FcmService().init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: ElevatedButton(
        onPressed: () async {
          await FirebaseMessaging.instance.subscribeToTopic("all");
        },
        child: const Text("Subscribe to Critical Alert Topic"),
      )),
    );
  }
}
