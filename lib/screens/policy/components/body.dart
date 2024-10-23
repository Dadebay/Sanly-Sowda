import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/components/something_went_wrong.dart';
import 'package:jummi/controllers/main_controller.dart';
import 'package:jummi/size_config.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController mainC = Get.put(MainController());
    return mainC.policiesLoading.value == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : mainC.policiesError.value != ''
            ? SomethingWentWrong(text: mainC.policiesError.value, press: mainC.getPolicies)
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < mainC.policies.length; i++)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            mainC.policies[i].title_tm == null
                                ? const SizedBox()
                                : Text(
                                    Get.locale == const Locale('tm', 'TM') ? mainC.policies[i].title_tm! : mainC.policies[i].title_ru!,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: getProportionateScreenWidth(18),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                            mainC.policies[i].content_tm == null
                                ? const SizedBox()
                                : Text(
                                    Get.locale == const Locale('tm', 'TM') ? mainC.policies[i].content_tm! : mainC.policies[i].content_ru!,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: getProportionateScreenWidth(14),
                                    ),
                                    // textAlign: TextAlign.justify,
                                  ),
                            const SizedBox(height: 10),
                          ],
                        ),
                    ],
                  ),
                ),
              );
  }
}
