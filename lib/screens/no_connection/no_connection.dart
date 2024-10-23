import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/screens/splash/splash_page.dart';

class NoConnection extends StatefulWidget {
  const NoConnection({super.key});

  @override
  State<NoConnection> createState() => _NoConnectionState();
}

class _NoConnectionState extends State<NoConnection> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 60,
              ),
              const SizedBox(height: 20),
              Text('No internet connection'.tr),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.off(const SplashPage()),
                child: Text('Try again'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
