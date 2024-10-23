import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/components/default_button.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/screens/settings/settings_screen.dart';
import 'package:jummi/services/account_services.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _txtControllerBody = TextEditingController();
  late bool _loading = false;
  late bool success = false;

  void sendRequest() async {
    final response = await AccountService.setReferral(
      _txtControllerBody.text,
    );

    if (response.statusCode == 200) {
      await checkToken().then((value) {
        setState(() {
          _loading = false;
          success = true;
        });
        Get.to(const SettingsScreen());
      });
    } else if (response.statusCode == 400) {
      setState(() {
        _loading = false;
      });
      Get.snackbar(
        'Referral error',
        json.decode(response.body)['detail'],
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.black,
        margin: const EdgeInsets.all(10),
      );
    } else {
      setState(() {
        _loading = false;
      });
      Get.snackbar(
        'Referral error',
        json.decode(response.body)['detail'],
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.black,
        margin: const EdgeInsets.all(10),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.05),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: width * 0.05,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Referral code can be entered only once. The code may consist of uppercase Latin letters and numbers.'.tr,
                          style: TextStyle(
                            fontSize: width * 0.036,
                            height: 1.2,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.03),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      controller: _txtControllerBody,
                      validator: (value) => value!.isEmpty || value.length < 4 || value.length > 10 ? 'Code length must be greater than 3 or smaller than 11!'.tr : null,
                      decoration: InputDecoration(
                        hintText: 'Referral code'.tr,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 3,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DefaultButton(
                    press: () {
                      if (_formKey.currentState!.validate() && (_txtControllerBody.text.length <= 10 || _txtControllerBody.text.length >= 4)) {
                        setState(() {
                          _loading = true;
                        });
                        sendRequest();
                      }
                    },
                    text: 'Confirm'.tr,
                  ),
                ],
              ),
            ),
    );
  }
}
