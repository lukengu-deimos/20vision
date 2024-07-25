import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:visionapp/main.dart';
import 'package:visionapp/presentation/pages/main/alert_page.dart';
import 'package:visionapp/presentation/pages/main/home_page.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void initializeNotifications() async {

  var initializationSettingsAndroid =
  const AndroidInitializationSettings('@mipmap/launcher_icon');
  var initializationSettingsIOS = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: onDidReceiveLocalNotification,
  );
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );


  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
  );
  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
}

void  showNotification(String title, String body, String payload) async {

  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );
  var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );
  print("Sending notification to device: $title $body");
  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    platformChannelSpecifics,
    payload: payload,
  );
}

Future onSelectNotification(String payload) async {
  // Handle notification tapped logic here
  print("Notification clicked with payload: $payload");

}
void onDidReceiveNotificationResponse(NotificationResponse
notificationResponse) async {
  BuildContext? context = navigatorKey.currentContext;
  // Handle notification tapped logic here
  print("Notification clicked with payload: ${notificationResponse.payload}");
  final notification = jsonDecode(notificationResponse.payload!);
  if (notification['extras']['type'] == 'alert') {
    await Navigator.pushAndRemoveUntil(
      context!,
      MaterialPageRoute<void>(
          builder: (context) => const HomePage(forceLoad:3,)),
            (route) => false
    );
  }
}


Future onDidReceiveLocalNotification(
    int id, String ?title, String ?body, String ?payload) async {
  // Handle iOS local notification received logic here
  print("Notification received with payload: $payload");
}