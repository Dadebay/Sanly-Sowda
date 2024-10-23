// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:jummi/controllers/home_controller.dart';
import 'package:jummi/controllers/main_controller.dart';
import 'package:jummi/screens/home/components/banner/home_banner.dart';
import 'package:jummi/screens/home/components/discount_banner.dart';
import 'package:jummi/screens/home/components/popular_products.dart';
import 'package:jummi/screens/home/components/vip_products.dart';
import 'package:jummi/screens/home/components/vip_stores.dart';
import 'package:jummi/size_config.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late String myToken = '';
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final MainController _mainController = Get.put(MainController());
  final HomeController _homeController = Get.put(HomeController());

  void initInfo() {
    const androidInitialize = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInitialize = DarwinInitializationSettings();
    const initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onDidReceiveNotificationResponse: (payload) async {
        try {} catch (e) {}
        return;
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'jummi-d106c',
        'jummi-d106c',
        importance: Importance.max,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
        // sound: RawResourceAndroidNotificationSound('notification'),
      );
      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails(),
      );
      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        platformChannelSpecifics,
        payload: message.data['body'],
      );
    });
  }

  void requestPermission() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    final NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    } else {}
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection('UserTokens').doc('User2').set({
      'token': token,
    });
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      myToken = value!;
      saveToken(value);
    });
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    getToken();
    initInfo();
    _mainController.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.onInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    void refreshContent() async {
      // BannerController _bannerController = Get.put(BannerController());
      final HomeController homeC = Get.put(HomeController());
      homeC.getBanners();
      homeC.getTopDiscount();
      homeC.getTopCategories();
      homeC.getHomeStores();
      homeC.getPopularProducts();
      homeC.getHomeProducts();
      _mainController.getNotifications();
    }

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          refreshContent();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              HomeBanner(),
              SizedBox(height: getProportionateScreenWidth(1)),
              VipStores(),
              SizedBox(height: getProportionateScreenWidth(20)),
              DiscountBanner(),
              SizedBox(height: getProportionateScreenWidth(20)),
              // Categories(),
              // SizedBox(height: getProportionateScreenWidth(20)),
              NewProducts(),
              SizedBox(height: getProportionateScreenWidth(20)),
              VipProducts(),
              SizedBox(height: getProportionateScreenWidth(20)),
              // SizedBox(height: 400),
            ],
          ),
        ),
      ),
    );
  }
}
