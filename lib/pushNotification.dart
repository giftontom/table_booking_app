import 'dart:developer';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import './controllers/apiController.dart';
import 'appTheme.dart';

class PushNotificationService {
  final apiController = Get.put(APIController());

  Future initialise() async {
    await Firebase.initializeApp();
    FirebaseMessaging _fcm = FirebaseMessaging.instance;
    await _fcm.requestPermission(sound: true, alert: true, badge: true);
    // _fcm.onIosSettingsRegistered.listen((IosNotificationSettings setting) {
    //   print('IOS Setting Registered');
    // });
    String token = await _fcm.getToken();
    log("FirebaseMessaging token: $token");

    apiController.fcmToken.value = token;

    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      showNotification(initialMessage);
      log("onResume: $initialMessage");
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      showNotification(message);
      log("onResume: $message");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
      log('onMessage: $message');
    });
  }

  void showNotification(RemoteMessage event) async {
    var printText = "Notification";
    printText +=
        "\n" + event.notification.title + "\n" + event.notification.body;
    showSimpleNotification(
      Text(printText),
      background: AppTheme.getTheme().primaryColor,
    );
  }
}
