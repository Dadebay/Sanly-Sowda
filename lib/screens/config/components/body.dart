import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/screens/policy/policy_screen.dart';
import 'package:jummi/size_config.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${"Language".tr}: ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.screenWidth * 0.045,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.updateLocale(
                      Get.locale == const Locale('tm', 'TM') ? const Locale('ru', 'RU') : const Locale('tm', 'TM'),
                    );
                  },
                  child: Text(
                    Get.locale == const Locale('tm', 'TM') ? 'Русский' : 'Türkmençe',
                    style: TextStyle(
                      fontSize: SizeConfig.screenWidth * 0.04,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextButton(
              onPressed: () => Get.to(const PolicyScreen()),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.black87,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Privacy policy, terms of services, and community guidlines.'.tr,
                      style: const TextStyle(
                        height: 1.2,
                        color: Colors.black87,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
