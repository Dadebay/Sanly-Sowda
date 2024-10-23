import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jummi/custom_widgets/notifcation_service.dart';
import 'package:jummi/firebase_options.dart';
import 'package:jummi/screens/splash/splash_page.dart';
import 'package:jummi/translations.dart';

import 'theme.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await FCMConfig().sendNotification(
    body: message.notification?.body ?? 'No body',
    title: message.notification?.title ?? 'No title',
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  await FCMConfig().requestPermission();
  await FCMConfig().initAwesomeNotification();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SanlySöwda',
      builder: (context, childd) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ), //set desired text scale factor here
          child: childd!,
        );
      },
      translations: Messages(),
      locale: Get.deviceLocale,
      transitionDuration: const Duration(milliseconds: 500),
      defaultTransition: Transition.fadeIn,
      theme: theme(),
      home: const SplashPage(),
    );
  }
}
