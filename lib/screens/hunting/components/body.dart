// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/controllers/main_controller.dart';
import 'package:jummi/screens/sign_in/sign_in_screen.dart';
import 'package:jummi/size_config.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late bool helpOpen = false;
  final MainController _mainC = Get.put(MainController());
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/fishing.png',
              fit: BoxFit.fitWidth,
              alignment: Alignment.topRight,
              opacity: const AlwaysStoppedAnimation(.2),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Column(
                children: [
                  _mainC.user.value.id == null
                      ? const SizedBox()
                      : Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                'Hunting texts'.tr,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            for (var i = 0; i < _mainC.user.value.searchTexts!.length; i++)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor.withOpacity(.5),
                                  border: Border.all(
                                    color: Colors.black12,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _mainC.user.value.searchTexts![i].text.toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        height: 1,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.remove),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                  const SizedBox(height: 5),
                  _mainC.user.value.id == null
                      ? OutlinedButton(
                          onPressed: () => Get.to(const SignInScreen()),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: kPrimaryColor,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            'Sign in to do hunting'.tr,
                            style: TextStyle(
                              fontSize: SizeConfig.screenWidth * 0.05,
                              fontWeight: FontWeight.w600,
                              height: 1,
                            ),
                          ),
                        )
                      : _mainC.user.value.searchTexts!.isEmpty
                          ? OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: kPrimaryColor,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                'Do hunting'.tr,
                                style: TextStyle(
                                  fontSize: SizeConfig.screenWidth * 0.05,
                                  fontWeight: FontWeight.w600,
                                  height: 1,
                                ),
                              ),
                            )
                          : OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: kPrimaryColor,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                '+'.tr,
                                style: TextStyle(
                                  fontSize: SizeConfig.screenWidth * 0.085,
                                  fontWeight: FontWeight.w600,
                                  height: 1,
                                ),
                              ),
                            ),
                  const SizedBox(height: 30),
                  Obx(
                    () => _mainC.huntingLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : _mainC.huntingError != ''
                            ? Text('Something went wrong!'.tr)
                            : SizedBox(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Text(
                                      Get.locale == const Locale('tm', 'TM') ? _mainC.hunting.value.title_tm.toString() : _mainC.hunting.value.title_ru.toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: SizeConfig.screenWidth * 0.05,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      Get.locale == const Locale('tm', 'TM') ? _mainC.hunting.value.content_tm.toString() : _mainC.hunting.value.content_ru.toString(),
                                      style: TextStyle(
                                        fontSize: SizeConfig.screenWidth * 0.037,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
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
