// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/components/something_went_wrong.dart';
import 'package:jummi/controllers/main_controller.dart';
import 'package:jummi/screens/help/components/contact.dart';
import 'package:jummi/size_config.dart';

class Body extends StatelessWidget {
  Body({super.key});

  final MainController _mainC = Get.put(MainController());

  void _refreshContacts() async {
    _mainC.getContacts();
  }

  void _refreshHelps() async {
    _mainC.getHelps();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Obx(
                () => _mainC.contactsLoading.value == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _mainC.contactsError.value != ''
                        ? SomethingWentWrong(
                            text: 'Something went wrong!'.tr,
                            press: _refreshContacts,
                          )
                        : _mainC.contacts.value.isEmpty
                            ? Center(
                                child: Text('No data'.tr),
                              )
                            : Column(
                                children: [
                                  for (var i = 0; i < _mainC.contacts.value.length; i++)
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${Get.locale == const Locale('tm', 'TM') ? _mainC.contacts.value[i].text!.tm : _mainC.contacts.value[i].text!.ru}: ",
                                            style: TextStyle(
                                              fontSize: getProportionateScreenWidth(16),
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              "${Get.locale == const Locale("tm", "TM") ? _mainC.contacts.value[i].value!.tm : _mainC.contacts.value[i].value!.ru}",
                                              style: TextStyle(
                                                fontSize: getProportionateScreenWidth(16),
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Obx(
                () => _mainC.helpsLoading.value == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _mainC.helpsError.value != ''
                        ? SomethingWentWrong(
                            text: 'Something went wrong!'.tr,
                            press: _refreshHelps,
                          )
                        : _mainC.helps.value.isEmpty
                            ? Center(
                                child: Text('No data'.tr),
                              )
                            : Column(
                                children: [
                                  for (var i = 0; i < _mainC.helps.value.length; i++)
                                    ExpansionTile(
                                      tilePadding: EdgeInsets.zero,
                                      subtitle: Text(
                                        "${Get.locale == const Locale("tm", "TM") ? _mainC.helps.value[i].content!.tm : _mainC.helps.value[i].content!.ru}",
                                        maxLines: 1,
                                      ),
                                      title: Text(
                                        "${Get.locale == const Locale("tm", "TM") ? _mainC.helps.value[i].title!.tm : _mainC.helps.value[i].title!.ru}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: getProportionateScreenWidth(16),
                                        ),
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "${Get.locale == const Locale("tm", "TM") ? _mainC.helps.value[i].content!.tm : _mainC.helps.value[i].content!.ru}",
                                              style: TextStyle(fontSize: getProportionateScreenWidth(14), color: Colors.black87),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
              ),
            ),
            const SizedBox(height: 10),
            const HelpContact(),
          ],
        ),
      ),
    );
  }
}
