import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jummi/controllers/main_controller.dart';
import 'package:jummi/screens/config/config_screen.dart';
import 'package:jummi/screens/ecommerce/ecommerce_screen.dart';
import 'package:jummi/screens/ecommerce_request/ecommerce_request.dart';
import 'package:jummi/screens/help/help_screen.dart';
import 'package:jummi/screens/home/home_screen.dart';
import 'package:jummi/screens/notifications/notifications_screen.dart';
import 'package:jummi/screens/settings/components/settings_menu_item.dart';
import 'package:jummi/screens/sign_in/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController mainC = Get.put(MainController());
    final double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        mainC.user.value.id == null
            ? const SizedBox()
            : Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${"Phone".tr}:",
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          mainC.user.value.phone.toString(),
                          style: TextStyle(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 5),
                    // Row(
                    //   children: [
                    //     Text(
                    //       "Referral code".tr + ":",
                    //       style: TextStyle(
                    //         fontSize: width * 0.045,
                    //         fontWeight: FontWeight.w600,
                    //         color: Colors.black,
                    //       ),
                    //     ),
                    //     SizedBox(width: 5),
                    //     _mainC.user.value.refCode == null
                    //         ? GestureDetector(
                    //             onTap: () {
                    //               Get.to(SetReferral());
                    //             },
                    //             child: Text(
                    //               "Set referral code".tr,
                    //               style: TextStyle(
                    //                 color: kPrimaryColor,
                    //               ),
                    //             ),
                    //           )
                    //         : Text(
                    //             _mainC.user.value.refCode.toString(),
                    //             style: TextStyle(
                    //               fontSize: width * 0.04,
                    //               fontWeight: FontWeight.w400,
                    //             ),
                    //           ),
                    //   ],
                    // ),
                    // SizedBox(height: 5),
                    // Row(
                    //   children: [
                    //     Text(
                    //       "Used referral code".tr + ":",
                    //       style: TextStyle(
                    //         fontSize: width * 0.045,
                    //         fontWeight: FontWeight.w600,
                    //         color: Colors.black,
                    //       ),
                    //     ),
                    //     SizedBox(width: 5),
                    //     Text(
                    //       _mainC.user.value.usedRefCode == null ? "-" : _mainC.user.value.usedRefCode.toString(),
                    //       style: TextStyle(
                    //         fontSize: width * 0.04,
                    //         fontWeight: FontWeight.w400,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          "${"Created at".tr}:",
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          mainC.user.value.createdAt != null ? DateFormat('dd.MM.yyyy / HH:mm:ss').format(mainC.user.value.createdAt!) : '12',
                          style: TextStyle(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
        mainC.user.value.id == null ? const SizedBox(height: 10) : const SizedBox(),
        mainC.user.value.id != null
            ? mainC.user.value.userEcommerce != null && mainC.user.value.userEcommerce!.id != null
                ? SettingsMenuItem(
                    icon: 'assets/icons/Shop Icon.svg',
                    text: 'Open my store'.tr,
                    press: () => Get.to(
                      EcommerceScreen(
                        ecommerce_id: mainC.user.value.userEcommerce!.id!,
                      ),
                    ),
                  )
                : SettingsMenuItem(
                    icon: 'assets/icons/Shop Icon.svg',
                    text: 'Create store'.tr,
                    press: () => Get.to(
                      const EcommerceRequest(),
                    ),
                  )
            : SettingsMenuItem(
                icon: 'assets/icons/User Icon.svg',
                text: 'Sign In'.tr,
                press: () => Get.to(
                  const SignInScreen(),
                ),
              ),
        // _mainC.user.value.id != null && _mainC.user.value.userEcommerce != null
        //     ? SettingsMenuItem(
        //         icon: "assets/icons/Cart Icon.svg",
        //         text: "Orders".tr,
        //         press: () => Get.to(
        //           OrdersScreen(),
        //         ),
        //       )
        //     : SizedBox(),
        SettingsMenuItem(
          icon: 'assets/icons/Bell.svg',
          text: 'Notifications'.tr,
          press: () => Get.to(
            const NotificationsScreen(),
          ),
        ),
        SettingsMenuItem(
          icon: 'assets/icons/Question mark.svg',
          text: 'Help Center'.tr,
          press: () => Get.to(const HelpScreen()),
        ),
        SettingsMenuItem(
          icon: 'assets/icons/Settings.svg',
          text: 'Settings'.tr,
          press: () {
            Get.to(const ConfigScreen());
          },
        ),
        mainC.user.value.id == null
            ? const SizedBox()
            : SettingsMenuItem(
                icon: 'assets/icons/Log out.svg',
                text: 'Logout'.tr,
                press: () {
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
                                backgroundColor: Colors.green,
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
              ),
      ],
    );
  }
}
