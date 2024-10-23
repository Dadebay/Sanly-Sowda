import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/screens/home/home_screen.dart';
import 'package:jummi/screens/no_connection/no_connection.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkConnection().then(
      (value) {
        if (value == true) {
          Timer(const Duration(seconds: 5), () {
            Get.off(const HomeScreen());
          });
        } else {
          Timer(const Duration(seconds: 5), () {
            Get.off(const NoConnection());
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/logo.svg',
                width: MediaQuery.of(context).size.width * 0.2,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sanly',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: const Color.fromARGB(255, 233, 120, 45),
                      fontSize: MediaQuery.of(context).size.width * 0.08,
                    ),
                  ),
                  Text(
                    'Söwda',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: const Color.fromARGB(255, 45, 114, 107),
                      fontSize: MediaQuery.of(context).size.width * 0.08,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
