import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/components/custom_bottom_nav_bar.dart';
import 'package:jummi/enums.dart';
import 'package:jummi/screens/home/home_screen.dart';
import 'package:jummi/screens/my_account/components/body.dart';
import 'package:jummi/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

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
        'My Account'.tr,
        style: TextStyle(
          fontSize: SizeConfig.screenWidth * 0.055,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Logout'.tr),
                  content: Text('Do you want to log out?'.tr),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        final SharedPreferences pref = await SharedPreferences.getInstance();
                        await pref.remove('access_token');
                        Get.snackbar(
                          'Logout'.tr,
                          'You have logged out successfully!'.tr,
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                          icon: const Icon(
                            Icons.login,
                            color: Colors.white,
                          ),
                        );
                        await Get.to(const HomeScreen());
                      },
                      child: Text('Yes'.tr),
                    ),
                  ],
                );
              },
            );
          },
          icon: Icon(
            Icons.logout,
            color: Colors.red,
            size: SizeConfig.screenWidth * 0.06,
          ),
        ),
      ],
    );
  }
}
