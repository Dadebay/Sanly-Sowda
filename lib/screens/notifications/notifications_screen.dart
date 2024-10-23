import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/components/custom_bottom_nav_bar.dart';
import 'package:jummi/enums.dart';
import 'package:jummi/size_config.dart';

import 'components/body.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarBuilder(context),
        body: const Body(),
        bottomNavigationBar: const CustomBottomNavBar(
          selectedMenu: MenuState.profile,
        ),
      ),
    );
  }

  AppBar appBarBuilder(BuildContext context) {
    return AppBar(
      toolbarHeight: SizeConfig.screenHeight * 0.07,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.chevron_left_rounded,
          size: 28,
        ),
      ),
      centerTitle: true,
      title: Text(
        'Notifications'.tr,
        style: TextStyle(fontSize: SizeConfig.screenWidth * 0.055),
      ),
    );
  }
}
