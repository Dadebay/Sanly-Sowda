import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/controllers/main_controller.dart';
import 'package:jummi/screens/ecommerce/ecommerce_screen.dart';
import 'package:jummi/screens/ecommerce_request/ecommerce_request.dart';
import 'package:jummi/screens/last_visited_porducts/last_visited_products.dart';
import 'package:jummi/screens/set_referral/set_referral.dart';
import 'package:jummi/size_config.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController mainC = Get.put(MainController());
    final double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "${"Referral code".tr}:",
                      style: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 5),
                    mainC.user.value.refCode == null
                        ? GestureDetector(
                            onTap: () {
                              Get.to(const SetReferral());
                            },
                            child: Text(
                              'Set referral code'.tr,
                              style: const TextStyle(
                                color: kPrimaryColor,
                              ),
                            ),
                          )
                        : Text(
                            mainC.user.value.refCode.toString(),
                            style: TextStyle(
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "${"Used referral code".tr}:",
                      style: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      mainC.user.value.usedRefCode == null ? '-' : mainC.user.value.usedRefCode.toString(),
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
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
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "${"My store".tr}:",
                      style: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 5),
                    mainC.user.value.userEcommerce != null && mainC.user.value.userEcommerce!.id != null
                        ? GestureDetector(
                            onTap: () => Get.to(
                              EcommerceScreen(
                                ecommerce_id: mainC.user.value.userEcommerce!.id!,
                              ),
                            ),
                            child: Text(
                              'Open my store'.tr,
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: width * 0.04,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () => Get.to(const EcommerceRequest()),
                            child: Text(
                              'Create store'.tr,
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: width * 0.04,
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 10,
            ),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: const WidgetStatePropertyAll(Colors.white),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(
                    horizontal: width * 0.05,
                    vertical: width * 0.04,
                  ),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                ),
              ),
              onPressed: () => Get.to(const LastVisitedProducts()),
              child: Row(
                children: [
                  const Icon(Icons.history_rounded),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Last visited products'.tr,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: SizeConfig.screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.black,
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
