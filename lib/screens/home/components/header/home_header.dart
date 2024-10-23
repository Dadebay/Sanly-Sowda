// ignore_for_file: empty_catches, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/controllers/main_controller.dart';
import 'package:jummi/screens/ecommerce/ecommerce_screen.dart';
import 'package:jummi/screens/home/components/header/icon_btn_with_counter.dart';
import 'package:jummi/screens/home/components/header/search_filed.dart';
import 'package:jummi/screens/notifications/notifications_screen.dart';
import 'package:jummi/screens/starter/components/ScanScreen.dart';
import 'package:jummi/size_config.dart';
import 'package:scan/scan.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    super.key,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  String qrcode = 'Unknown';
  final MainController _mainController = Get.put(MainController());

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {} on PlatformException {}
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(10),
        vertical: getProportionateScreenHeight(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 33,
                              vertical: 20,
                            ),
                          ),
                          onPressed: () => Get.to(const ScanScreen()),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_rounded,
                                color: kPrimaryColor,
                                size: SizeConfig.screenWidth * 0.08,
                              ),
                              const SizedBox(height: 10),
                              Text('Camera'.tr),
                            ],
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 33,
                              vertical: 20,
                            ),
                          ),
                          onPressed: () async {
                            final res = await ImagePicker().getImage(source: ImageSource.gallery);
                            if (res != null) {
                              final String? str = await Scan.parse(res.path);
                              if (str != null) {
                                await Get.to(
                                  EcommerceScreen(
                                    ecommerce_id: int.parse(str),
                                  ),
                                );
                              } else {
                                Navigator.pop(context);
                              }
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.perm_media,
                                color: kPrimaryColor,
                                size: SizeConfig.screenWidth * 0.08,
                              ),
                              const SizedBox(height: 10),
                              Text('Gallery'.tr),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: Icon(
              Icons.qr_code_scanner,
              color: kPrimaryColor,
              size: width * 0.06,
            ),
          ),
          const SearchField(),
          Row(
            children: [
              Obx(
                () => IconBtnWithCounter(
                  svgSrc: 'assets/icons/Bell.svg',
                  press: () => Get.to(const NotificationsScreen()),
                  numOfItems: _mainController.notifications.length,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
